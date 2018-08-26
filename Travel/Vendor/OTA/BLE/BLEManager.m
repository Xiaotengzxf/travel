//
//  BLEManager.m
//  AlexaSDKHost
//
//  Created by ocean on 2017/6/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BLEManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIApplication.h>
#import "BLEDefine.h"
#import "BLEDevice+OTA.h"
#import <ZXMoblie/UtilityToolkit.h>
#import "BLEManager+PhoneCall.h"
#import <ZXMoblie/ZXMoblie.h>

#define BLE_CONNECT_TIMEOUT_SEC 30


@interface BLEManager()<CBCentralManagerDelegate> {
    NSHashTable* _delegates;
    
    dispatch_queue_t _workingQueue;
    CBCentralManager* _centralManager;
    NSArray* _restoreDevices;
    
    NSTimeInterval _startConnectTimestamp;
    NSTimer* _connectWatchdogTimer;
    CBPeripheral* _connectingPeripheral; //正在连接中的外设
    float _fmFrequency; //当前的fm频率
}
@property (nonatomic,assign,readwrite) BOOL managerEnabled;
@property (nonatomic,strong,readwrite) BLEDevice* currentDevice;
@property (nonatomic,strong,readwrite) BLEDevice* lastDevice;
@property (nonatomic,assign,readwrite) BLEDeviceConnectStatus status;
@property (nonatomic,strong,readwrite) NSMutableArray* knownDevices;
@property (nonatomic,assign,readwrite) BLECentralManagerState centralState;
@end

@implementation BLEManager

+(instancetype)sharedManager
{
    static BLEManager* theManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theManager = [[BLEManager alloc] init];
    });
    return theManager;
}

+(void)jumpToSystemBluetoothConfigPage
{
    NSString* urlStr = nil;
    if (system_version() < 10.0) {
        urlStr = @"prefs:root=Bluetooth";
    }else{
        urlStr = @"App-Prefs:root=Bluetooth";
    }
    NSURL* url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

+(void)jumpToAppConfigPage
{
    //两种跳转方法，一个手动获取到自身的bundle id并填写下方的参数
//    NSString* urlStr = @"prefs:root=ow.zhixin.AlexaSDKHost";
//    NSURL* url = [NSURL URLWithString:urlStr];
//    [[UIApplication sharedApplication] openURL:url];
    //另一个，直接使用内置的链接（iOS 8.0+）
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _workingQueue = dispatch_queue_create("BLE.manager.working.queue", NULL);
        NSDictionary *option = @{CBCentralManagerOptionRestoreIdentifierKey:BLECentralRestoreId};
//        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:option];
        
        self.knownDevices = [NSMutableArray array];
        _delegates = [NSHashTable weakObjectsHashTable];
        
        _fmFrequency = [self loadFMFrequency];
        
        [self initPhoneCallDirector];
    }
    return self;
}


#pragma mark - logic

-(void)enable
{
    [self enableWithModifyConnectStatus:NO];
}

-(void)enableWithModifyConnectStatus:(BOOL)modify
{
    self.managerEnabled = YES;
    if (_centralManager.state == CBManagerStatePoweredOn) {
        [self startScan];
        if (modify) {
            self.connectStatus = BLEDeviceConnectStatusScaning;
        }
        // 直接重连上次设备
        if (self.lastDevice) {
            [self doConnectCBPeripheral:self.lastDevice.peripheral];
        }
    }
}

-(void)disable
{
    self.managerEnabled = NO;
    if (self.currentDevice != nil) {
        [_centralManager cancelPeripheralConnection:self.currentDevice.peripheral];
        if (self.connectStatus == BLEDeviceConnectStatusConnected) {
            self.connectStatus = BLEDeviceConnectStatusDisconnecting;
        }
    }else{
        self.connectStatus = BLEDeviceConnectStatusDisconnect;
    }
}

-(NSArray *)deviceList
{
    return _knownDevices;
}

-(NSArray *)savedConnectedDevices
{
    NSString* saved_uuid = [self lastConnectIdentifier];
    if (saved_uuid != nil) {
        return @[saved_uuid];
    }else{
        return nil;
    }
}

-(void)clearSavedDeviceInfo
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:USER_DEFAULT_KEY_LAST_DEVICE_ID];
    [ud removeObjectForKey:USER_DEFAULT_KEY_LAST_DEVICE_NAME];
}

-(void)connectCBPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral == nil) {
        return ;
    }
    if (self.currentDevice != nil) {
        [_centralManager cancelPeripheralConnection:self.currentDevice.peripheral];
        if (self.connectStatus == BLEDeviceConnectStatusConnected) {
            self.connectStatus = BLEDeviceConnectStatusDisconnecting;
        }
    }
//    self.connectStatus = BLEDeviceConnectStatusConnencting;
    [self doConnectCBPeripheral:peripheral];
}

-(void)setCarkitInfo:(NSString *)carkit
{
    NSString* oldCarkit = [self carkitInfo];
    [self saveCarkitInfo:carkit];
    if (![oldCarkit isEqualToString:carkit]) { //如果修改了模式，则需要断开重连
        if (self.currentDevice != nil) {
            NSLog(@"modify carkit mode, should disconnet it!");
            [_centralManager cancelPeripheralConnection:self.currentDevice.peripheral];
            if (self.connectStatus == BLEDeviceConnectStatusConnected) {
                self.connectStatus = BLEDeviceConnectStatusDisconnecting;
            }
        }
    }
}

-(NSString *)carkitInfo
{
    return [self loadCarkitInfo];
}

-(void)setFMFrequency:(float)fm
{
    _fmFrequency = fm;
    if (self.currentDevice != nil) {
        NSString* event = [NSString stringWithFormat:kDeviceEventSetFM_f,fm];
        [self.currentDevice writeDeviceEvent:event];
        
        [self saveFMFrequency:fm];
    }
}

-(float)FMFrequencyNeedRefreshFromDevice:(BOOL)refresh
{
    if (self.currentDevice != nil && refresh) {
        [self.currentDevice writeDeviceEvent:kDeviceEventGetFM];
    }
    return _fmFrequency;
}

-(NSString *)lastDeviceName
{
    if (self.currentDevice != nil) {
        return [self.currentDevice name];
    }
    return [self lastConnectedDeviceName];
}

-(void)addDelegate:(id<BLEManagerDelegate>)delegate
{
    if(![delegate conformsToProtocol:@protocol(BLEManagerDelegate)]) {
        return ;
    }
    [_delegates addObject:delegate];
}

-(void)removeDelegate:(id<BLEManagerDelegate>)delegate
{
    if (delegate == nil) {
        return ;
    }
    [_delegates removeObject:delegate];
}

-(void)doConnectCBPeripheral:(CBPeripheral *)peripheral
{
    if (self.connectStatus == BLEDeviceConnectStatusConnencting || self.connectStatus == BLEDeviceConnectStatusConnected) {
        return;
    }
    NSLog(@"try to connect to peripheral %@",peripheral);
    self.connectStatus = BLEDeviceConnectStatusConnencting;
    [_centralManager connectPeripheral:peripheral options:nil];
    [self installConnectWatchdogTimer:peripheral];
}

-(void)installConnectWatchdogTimer:(CBPeripheral *)peripheral
{
    //TODO: 考虑对每个peripheral封装一个timer（到BLEDevice里边）
    _startConnectTimestamp = [[NSDate date] timeIntervalSince1970];
    _connectingPeripheral = peripheral;
    _connectWatchdogTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(onConnectWatchdogTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_connectWatchdogTimer forMode:NSDefaultRunLoopMode];
}

-(void)onConnectWatchdogTimer:(NSTimer*)timer
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - _startConnectTimestamp > BLE_CONNECT_TIMEOUT_SEC && _connectingPeripheral != nil) {
        //超时未连接上，先断开连接
        [_centralManager cancelPeripheralConnection:_connectingPeripheral];
        if (self.connectStatus == BLEDeviceConnectStatusConnected) {
            self.connectStatus = BLEDeviceConnectStatusDisconnecting;
        }
        [_centralManager stopScan];
        [self uninstallConnectWatchdogTimer];
    }
}

-(void)uninstallConnectWatchdogTimer
{
    [_connectWatchdogTimer invalidate];
    _connectWatchdogTimer = nil;
    _connectingPeripheral = nil;
}

-(void)onDeviceNegotiationFinished:(BOOL)result
{
    NSLog(@"onDeviceNegotiationFinished >> %@",result ? @"YES" : @"NO");
    if (result) {
        [self saveDeviceIdentifier:self.currentDevice.peripheral.identifier.UUIDString];
        [self saveDeviceName:self.currentDevice.peripheral.name];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BLEDeviceDidConnectedNotification object:nil];
        });
        [self stopScan];
        [self uninstallConnectWatchdogTimer];
        
        self.connectStatus = BLEDeviceConnectStatusConnected;
        [self.currentDevice queryDeviceVersionInfos];
    }else{
        [self startScan];
        
        self.connectStatus = BLEDeviceConnectStatusDisconnect;
    }
}

-(NSString *)onDeviceNeedCarkitInfo
{
    NSString* rtn = [self loadCarkitInfo];
    if ([rtn length] == 0) {
        rtn = @"no";
    }
    return rtn;
}

#pragma mark - logic : ota
- (BOOL)checkOTAIfNeeded {
    return [self.currentDevice checkUpdateIfNeed];
}

- (void)startOTA {
    [self.currentDevice setOTADirPath: @""];
    [self.currentDevice startOTAProcedure];
}

#pragma mark - logic : private

-(void)startScan {
    NSLog(@"BLE start scan....");
    
    [_knownDevices removeAllObjects];
    
    NSArray* uuids = @[CBUUID_SERVICE_MAIN];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"in background mode");
        [_centralManager scanForPeripheralsWithServices:uuids options:nil];
    }else{
        NSLog(@"in foreground mode");
        [_centralManager scanForPeripheralsWithServices:uuids options:nil];
    }
}

-(void)stopScan {
    [_centralManager stopScan];
    
}

-(BOOL)isRoavDevice:(CBPeripheral*)peripheral
{
#warning 临时判断F4设备
    return [peripheral.name hasPrefix:@"Roav F4"];
}

-(void)saveDeviceIdentifier:(NSString*)uuid
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:uuid forKey:USER_DEFAULT_KEY_LAST_DEVICE_ID];
    [userDefaults synchronize];
}

-(NSString*)lastConnectIdentifier
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_DEFAULT_KEY_LAST_DEVICE_ID];
}

-(void)saveDeviceName:(NSString*)deviceName
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceName forKey:USER_DEFAULT_KEY_LAST_DEVICE_NAME];
    [userDefaults synchronize];
}

-(NSString*)lastConnectedDeviceName
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_DEFAULT_KEY_LAST_DEVICE_NAME];
}

-(void)saveCarkitInfo:(NSString*)carkit
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:carkit forKey:USER_DEFAULT_KEY_CARKIT_INFO];
    [userDefaults synchronize];
}

-(NSString*)loadCarkitInfo
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_DEFAULT_KEY_CARKIT_INFO];
}

-(void)saveFMFrequency:(float)frequency
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:frequency forKey:USER_DEFAULT_KEY_FM_FREQUENCY];
    [userDefaults synchronize];
}

-(float)loadFMFrequency
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:USER_DEFAULT_KEY_FM_FREQUENCY];
}


#pragma mark - peripheral manager delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            NSLog(@"CBManagerStatePoweredOn");
            if (self.managerEnabled) {
                if ([_restoreDevices count] > 0) {
                    [self connectCBPeripheral:[_restoreDevices lastObject]];
                    _restoreDevices = nil;
                }
                [self startScan];
                if (self.lastDevice) {
                    [self doConnectCBPeripheral:self.lastDevice.peripheral];
                }
            }
            break;
        }
        case CBManagerStatePoweredOff: {
            NSLog(@"CBManagerStatePoweredOff");
            self.currentDevice = nil;
            [_knownDevices removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:BLEDeviceDidDisconnectedNotification object:nil];
            });
            break;
        }
        case CBManagerStateResetting: {
            NSLog(@"CBManagerStatePoweredResetting");
            break;
        }
        case CBManagerStateUnsupported: {
            
            break;
        }
        case CBManagerStateUnauthorized: {
            NSLog(@"CBManagerStateUnauthorized");
            break;
        }
        default:
            break;
    }
    self.centralState = central.state;
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
    NSLog(@"centralManager willRestoreState ");
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    _restoreDevices = [peripherals copy];
    for (CBPeripheral *peripheral in peripherals) {
        NSLog(@"restore : %@",peripheral);
    }
    [_knownDevices addObjectsFromArray:peripherals];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSLog(@"didDiscoverPeripheral %@",peripheral);
    
    if (![_knownDevices containsObject:peripheral] && [self isRoavDevice:peripheral]) {
        [_knownDevices addObject:peripheral];
        [[NSNotificationCenter defaultCenter] postNotificationName:BLEDeviceDidDiscoverPeripheralNotification object:peripheral];
    }
    
    
    //连接上一次记录下来的设备
    NSString* lastIdentifier = [self lastConnectIdentifier];
    if ([peripheral.identifier.UUIDString isEqualToString:lastIdentifier]) {
         [self doConnectCBPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral %@",peripheral.name);
    
    if (self.currentDevice == nil) {
        self.currentDevice = [[BLEDevice alloc] initWithPeripheral:peripheral];
        self.currentDevice.manager = self;
    }else{
        [self.currentDevice renewPeriperal:peripheral];
    }
    
    //鉴于还没有跟设备进行进一步service沟通，这里就不取消timer
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.lastDevice = self.currentDevice;
    self.currentDevice = nil;
    NSLog(@"didDisconnectPeripheral %@",peripheral.name);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BLEDeviceDidDisconnectedNotification object:peripheral];
    });
    self.connectStatus = BLEDeviceConnectStatusDisconnect;
    // 断电或者信号弱导致断开则搜索重连，主动断开的话error为nil，超时断开也是nil
    if (self.managerEnabled && _centralManager.state == CBManagerStatePoweredOn) {

//        [self startScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
{
    NSLog(@"didFailToConnectPeripheral %@",peripheral.name);
    self.connectStatus = BLEDeviceConnectStatusDisconnect;
    [self uninstallConnectWatchdogTimer];
    self.currentDevice = nil;
    self.lastDevice = nil;
}


#pragma mark - setter
-(void)setConnectStatus:(BLEDeviceConnectStatus)connectStatus
{
    if (connectStatus == _connectStatus) {
        return ;
    }
    BLEDeviceConnectStatus oldStatus = _connectStatus;
    _connectStatus = connectStatus;
    for (id<BLEManagerDelegate> delegate in _delegates) {
        if([delegate respondsToSelector:@selector(onBLEDeviceConnectStatusChanged:)]) {
            [delegate onBLEDeviceConnectStatusChanged:_connectStatus];
        }
    }
}

@end
