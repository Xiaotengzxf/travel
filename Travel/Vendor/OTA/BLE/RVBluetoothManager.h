//
//  BluetoothManager.h
//  AlexaSDKHost
//
//  Created by ocean on 06/09/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RVBluetoothDevice.h"

typedef NS_ENUM(NSInteger, RVDeviceConnectStatus)
{
    RVDeviceConnectStatusDisconnected,
    RVDeviceConnectStatusConnected
};

@protocol BluetoothManagerDelagate <NSObject>

-(void)bluetoothManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral;

@end

@interface RVBluetoothManager : NSObject

@property (nonatomic, strong, readonly) RVBluetoothDevice * currentDevice;
@property (nonatomic, assign, readonly) ROVDeviceType currentDeviceType;
@property (assign, nonatomic) RVDeviceConnectStatus connectStatus;

+ (instancetype)shareManager;

- (void)startScanPeripheral;
// 启动App,连接上次设备，需要搜索连接
- (void)startScanPeripheralWithUUID:(NSString *)uuid;
- (void)stopScanPeripheral;
// 会把重连的信息清除掉，当进入切换设备界面时候
- (void)clearScanReconection;

- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)disconnectCurrentDevice;
- (void)reConnectCurrentDevice;

- (BOOL)checkIsNormalDisconnect;
- (NSArray *)scanedPeripherals;
- (CBManagerState)centralManagerState;
- (BOOL)isScaning;
- (BOOL)isScanReconnecting;

@end
