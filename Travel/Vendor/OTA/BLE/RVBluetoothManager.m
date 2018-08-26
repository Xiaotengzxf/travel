//
//  BluetoothManager.m
//  AlexaSDKHost
//
//  Created by ocean on 06/09/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

#import "RVBluetoothManager.h"
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>
#import "RVBluetoothDeviceF3.h"
//#import <OWAccount/OWAccount.h>

#define kBTConnectTimeout                            30

@interface RVBluetoothManager ()<CBCentralManagerDelegate>
{
    CBCentralManager *centralManager;
    NSMutableArray *discoverPeripherals;
    NSMutableArray *reconnectUUIDs;
    RVBluetoothDevice *currentDevice;
    RVBluetoothDevice *lastConnectDevice;
    CTCallCenter* callCenter;
    NSTimer *connectionTimer;
    NSTimer *scanReconnectTimer;
    CBPeripheral *restoredPeripheral;
    NSString *needToScanConnectUUID;
    ROVDeviceType currentDeviceType;
    
    BOOL needToScan; // 记录scan设备时蓝牙没打开的情况，poweron时继续扫描
    BOOL isScanReconecting;
    BOOL isNormalDisconnect; // YES:手动断开，NO:超时断开链接
    BOOL isConnectTimeouting;
    NSInteger isDisconnectWithCallback;
}

@end

@implementation RVBluetoothManager
@synthesize currentDevice;
@synthesize currentDeviceType;

+ (instancetype)shareManager {
    static RVBluetoothManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[RVBluetoothManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_shareInstance selector:@selector(getNewVoltage:) name:kNFBLEDidGetBatteryVoltage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_shareInstance selector:@selector(iBeaconDidEnterRegion:) name:BEACONDidEnterRegionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_shareInstance selector:@selector(iBeaconDidEnterRegion:) name:BEACONDidRangingNearByNotification object:nil];
    });
    return _shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    isDisconnectWithCallback = -1;
    discoverPeripherals = [[NSMutableArray alloc]init];
    reconnectUUIDs = [[NSMutableArray alloc]init];
    
    currentDeviceType = (ROVDeviceType)[[RVBluetoothDevice lastConnectDeviceInfo][@"type"] integerValue];
    currentDeviceType = currentDeviceType > 0 ? currentDeviceType : ROVDeviceTypeUnknown;
    
    [self observeLogInOutEvent];

//    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey,
//                            @"com.oceanwing.com.BluetoothRestore", CBCentralManagerOptionRestoreIdentifierKey,
//                            nil];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey,
                            nil];
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:option];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    NSLog(@"willRestoreState %@", dict);

}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
//   NSLog(@"didDiscoverPeripheral %@",peripheral.name);
    
    if ([RVBluetoothDevice isTargetDevice:peripheral] && ![discoverPeripherals containsObject:peripheral]) {
        [discoverPeripherals addObject:peripheral];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLEDidDiscoverPeripheral object:peripheral userInfo:nil];
    }
    
    if (isScanReconecting && [reconnectUUIDs.lastObject isEqualToString:peripheral.identifier.UUIDString]) {
        [self connectPeripheral:peripheral];
        [self clearScanReconection];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"didConnectPeripheral %@",peripheral.name);
    
    isDisconnectWithCallback = 0;
    [self stopConnectTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLEDidConnectPeripheral object:peripheral userInfo:nil];
    lastConnectDevice = nil;
    [currentDevice startDiscover];
    
    if (reconnectUUIDs.count > 0) {
        [reconnectUUIDs removeAllObjects];
        [self stopScanPeripheral];
    }
    
    self.connectStatus = RVDeviceConnectStatusConnected;
//    [[NSFileManager defaultManager] removeItemAtPath:[RVCommonUtil parkingImageStoragePath] error:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CARFINDIMAGE_REMOVED object:nil];
//    [RVCommonUtil setLastConnectChangeTime:[NSDate date]];
//    [[BeaconRegionManager sharedManager] peripheralConnected];
//    [[BeaconRegionManager sharedManager] postLocalNotificationStr:[NSString stringWithFormat:@"did connect: %@", peripheral.name] category:nil];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    isDisconnectWithCallback = 1;
    [self dealDisconnectPeripheral:peripheral error:error];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error; {
    NSLog(@"didFailToConnectPeripheral %@, error: %@",peripheral.name, error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLEDidDisconnectPeripheral object:currentDevice.peripheral userInfo:nil];
    [self clearConnection];}

#pragma mark -

- (void)dealDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral %@, error: %@",peripheral.name, error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLEDidDisconnectPeripheral object:peripheral userInfo:error ? @{@"error" : error} : nil];
    
    if (isConnectTimeouting) {
        isConnectTimeouting = NO;
        return;
    }

    if (error != nil && currentDevice.peripheral == peripheral) {
        isNormalDisconnect = NO;
        [self scanReconnectWithUUID:peripheral.identifier.UUIDString];

//        // 防闪断
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self scanReconnectWithUUID:peripheral.identifier.UUIDString];
//        });
    }
    
    //[RVCommonUtil setLastConnectChangeTime:[NSDate date]];
    if(self.connectStatus != RVDeviceConnectStatusDisconnected) {
        self.connectStatus = RVDeviceConnectStatusDisconnected;
    }
}

- (void)startScanPeripheral {
    if (centralManager.state == CBManagerStatePoweredOn) {
        needToScan = NO;
        [self stopScanPeripheral];
        [discoverPeripherals removeAllObjects];
        [centralManager scanForPeripheralsWithServices:[RVBluetoothDevice allSupportServices] options:nil];
        if (isScanReconecting) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLEScanReconnectionStart object:reconnectUUIDs.lastObject];
        }
        NSLog(@"BLE start scan....");
    } else {
        needToScan = YES;
    }
}

- (void)startScanPeripheralWithUUID:(NSString *)uuid {
    if (self.currentDevice && (self.currentDevice.state == CBPeripheralStateConnected || self.currentDevice.state == CBPeripheralStateConnecting)) {
        return;
    }
    [self scanReconnectWithUUID:uuid];
}

- (void)stopScanPeripheral {
    [centralManager stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    // Check login
//    if ([OWAAccountManager sharedManager].token == nil) {
//        return;
//    }
    BOOL isRestored = peripheral.state == CBPeripheralStateConnected;
    ROVDeviceType type = [RVBluetoothDevice deviceTypeWithPeripheral:peripheral];
    
    if (isRestored) {
        NSLog(@"restored %@",peripheral.name);
        lastConnectDevice = nil;
        currentDeviceType = type;
        currentDevice = [[[RVBluetoothDevice deviceClassWithType:type] alloc] initWithPeripheral:peripheral];
        [self centralManager:centralManager didConnectPeripheral:peripheral];
    } else {
        if (self.currentDevice.state == CBPeripheralStateConnecting) {
            NSLog(@"connecting repeat!! %@",peripheral.name);
            return;
        }
        NSLog(@"connecting %@",peripheral.name);
        if (currentDevice && currentDevice.state == CBPeripheralStateConnected) {
            [self disconnectCurrentDevice];
        }
        lastConnectDevice = currentDevice;
        currentDeviceType = type;
        currentDevice = [[[RVBluetoothDevice deviceClassWithType:type] alloc] initWithPeripheral:peripheral];
        [centralManager connectPeripheral:peripheral options:nil];
        [self startConnectTimer];
    }
}

- (void)disconnectCurrentDevice {
    if (currentDevice) {
        [centralManager cancelPeripheralConnection:currentDevice.peripheral];
    }
    isNormalDisconnect = YES;
}

- (void)reConnectCurrentDevice {
    if (currentDevice) {
        [self connectPeripheral:currentDevice.peripheral];
    }
}

- (void)scanReconnectWithUUID:(NSString *)uuid {
    if (isScanReconecting || uuid.length == 0) {
        return;
    }
    isScanReconecting = YES;
    [reconnectUUIDs removeAllObjects];
    [reconnectUUIDs addObject:uuid];
    [self startScanPeripheral];
    [self startScanTimer];
}

- (void)clearScanReconection {
    isScanReconecting = NO;
    needToScan = NO;
    [reconnectUUIDs removeAllObjects];
    [self stopScanTimer];
    [self stopScanPeripheral];
}

#pragma mark -

- (BOOL)checkIsNormalDisconnect {
    return isNormalDisconnect;
}

- (NSArray *)scanedPeripherals {
    return discoverPeripherals;
}

- (CBManagerState)centralManagerState {
    return centralManager.state;
}

- (BOOL)isScaning {
    return [centralManager isScanning];
}

- (BOOL)isScanReconnecting {
    return ([self isScaning] && isScanReconecting);
}

#pragma mark -

- (void)observeLogInOutEvent {
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:OWAAccountDidLogoutNotification object:nil];
}

- (void)userDidLogout {
    [self clearAllConnection];
}

#pragma mark -
- (void)iBeaconDidEnterRegion:(id)sender {
    if (isNormalDisconnect) {
        return;
    }
    
    RVBluetoothManager *bleManager = self;
    if (bleManager.centralManagerState != CBCentralManagerStatePoweredOn) {
        return;
    }
    if(!bleManager.isScanReconnecting && !bleManager.isScaning) {
        if (bleManager.currentDevice != nil) {
            if (bleManager.currentDevice.state == CBPeripheralStateDisconnected) {
                [bleManager reConnectCurrentDevice];
            }
        } else {
            NSString *lastUUID = [RVBluetoothDevice lastConnectDeviceInfo][@"uuid"];
            if (lastUUID.length > 0) {
                [self scanReconnectWithUUID:lastUUID];
            }
        }
    }
}


#pragma mark - Connection Timer

- (void)startConnectTimer {
    [self stopConnectTimer];
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:kBTConnectTimeout target:self selector:@selector(handleConnectTimerCycle) userInfo:nil repeats:YES];
}

- (void)stopConnectTimer {
    if (connectionTimer && connectionTimer.isValid){
        [connectionTimer invalidate];
        connectionTimer = nil;
    }
}

-(void)handleConnectTimerCycle {
    NSLog(@"Connect timeout %@", currentDevice.peripheral.name);
    // In background, this way can restored app with bluetooth
//    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLETimeOutConnectPeripheral object:currentDevice.peripheral userInfo:nil];
        isConnectTimeouting = YES;
    if(currentDevice.peripheral) { // avoid possible crash
        [centralManager cancelPeripheralConnection:currentDevice.peripheral];
    }
        [self clearConnection];
//    }
}

- (void)clearConnection {
    [self stopConnectTimer];
    currentDevice = lastConnectDevice;
    lastConnectDevice = nil;
    needToScan = NO;
}

#pragma mark - Connection Timer

- (void)startScanTimer {
    [self stopScanTimer];
    scanReconnectTimer = [NSTimer scheduledTimerWithTimeInterval:kBTConnectTimeout target:self selector:@selector(handleScanTimerCycle) userInfo:nil repeats:YES];
}

- (void)stopScanTimer {
    if (scanReconnectTimer && scanReconnectTimer.isValid){
        [scanReconnectTimer invalidate];
        scanReconnectTimer = nil;
    }
}

-(void)handleScanTimerCycle {
    NSLog(@"Scan timeout %@", reconnectUUIDs.firstObject);
    // In background, this way can restored app with bluetooth
//    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [self clearScanReconection];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNFBLETimeOutScanReconnection object:nil userInfo:nil];
        //[RVEventTracer traceEventWithType:@"Connect Device" eventId:@"Connect-NO-Device"];
//    }
}

-(void) getNewVoltage : (NSNotification *) notif
{
    float newVolt = [notif.object floatValue];
    NSLog(@"the new volt read here is : %f",newVolt);
}

#pragma mark -

// 清除所有连接，比如退出账号后
- (void)clearAllConnection {
    [self stopScanTimer];
    [self stopConnectTimer];
    [self stopScanPeripheral];
    if (self.currentDevice && (self.currentDevice.state == CBPeripheralStateConnected || self.currentDevice.state == CBPeripheralStateConnecting)) {
        [self disconnectCurrentDevice];
    }
    needToScan = NO;
    isScanReconecting = NO;
    currentDevice = nil;
    lastConnectDevice = nil;
    [reconnectUUIDs removeAllObjects];
}

@end





