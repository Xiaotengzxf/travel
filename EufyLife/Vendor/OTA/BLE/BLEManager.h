//
//  BLEManager.h
//  AlexaSDKHost
//
//  Created by ocean on 2017/6/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"

typedef NS_ENUM(int32_t, BLEDeviceConnectStatus) {
    BLEDeviceConnectStatusDisconnect,
    BLEDeviceConnectStatusScaning,
    BLEDeviceConnectStatusConnencting,
    BLEDeviceConnectStatusDisconnecting,
    BLEDeviceConnectStatusConnected,
};

typedef NS_ENUM(NSInteger, BLECentralManagerState) {
    BLECentralManagerStateUnknown = 0,
    BLECentralManagerStateResetting,
    BLECentralManagerStateUnsupported,
    BLECentralManagerStateUnauthorized,
    BLECentralManagerStatePoweredOff,
    BLECentralManagerStatePoweredOn,
};

@protocol BLEManagerDelegate <NSObject>

-(void)onBLEDeviceConnectStatusChanged:(BLEDeviceConnectStatus)status;

@end

@class CTCallCenter;
@class CXCallObserver;

/**
 管理设备的BLE链接，创建BLEDevice等职责
 */
@interface BLEManager : NSObject {
    CTCallCenter* _callCenter;
    CXCallObserver* _callObserver;
}

@property (nonatomic,strong,readonly) NSArray* deviceList;

@property (nonatomic,assign,readonly) BOOL managerEnabled;

@property (nonatomic,strong,readonly) BLEDevice* currentDevice;

@property (nonatomic,assign,readonly) BLEDeviceConnectStatus connectStatus;

/**
 透传内部central manager的state
 */
@property (nonatomic,assign,readonly) BLECentralManagerState centralState;

/**
 当前扫描出来的蓝牙外设
 */
@property (nonatomic,strong,readonly) NSMutableArray* knownDevices;

+(instancetype)sharedManager;

+(void)jumpToSystemBluetoothConfigPage;

+(void)jumpToAppConfigPage;

-(void)enable;

-(void)enableWithModifyConnectStatus:(BOOL)modify;

-(void)disable;

-(void)connectCBPeripheral:(CBPeripheral*)peripheral;

-(void)clearSavedDeviceInfo;

/**
 保存着的之前连接过的设备

 @return 设备信息
 */
-(NSArray*)savedConnectedDevices;

#pragma mark - methods

-(void)addDelegate:(id<BLEManagerDelegate>)delegate;

-(void)removeDelegate:(id<BLEManagerDelegate>)delegate;

-(NSString*)lastDeviceName;

/**
 之前设置的carkit info

 @return "yes" or "no"
 */
-(NSString*)carkitInfo;

/**
 设置carkit info

 @param carkit 是否有car kit。有yes和no两种选项
 */
-(void)setCarkitInfo:(NSString*)carkit;

/**
 获取FM的频率。此方法将返回一个本地保存的结果，并根据标志，在需要时去设备异步获取。异步获取结果通过
 通知形式发送。
 @param refresh 是否从设备上再度获取
 @return 本地缓存的结果
 */
-(float)FMFrequencyNeedRefreshFromDevice:(BOOL)refresh;

/**
 设置FM频率

 @param fm 频率
 */
-(void)setFMFrequency:(float)fm;


- (BOOL)checkOTAIfNeeded;

-(void)startOTA;
#pragma mark - device `delegate`

/**
 在设备`真正`确认连接之后调用。此调用可能触发一个BLEDeviceDidConnectedNotification通知
 
 @param result 是否完成连接
 */
-(void)onDeviceNegotiationFinished:(BOOL)result;

/**
 在设备需要知道Carkit info的时候触发设备应该返回关于是否有carkit的信息。
 yes表示有车机,no表示无车机
 @return 一个字符串
 */
-(NSString*)onDeviceNeedCarkitInfo;

-(void)startScan;

@end
