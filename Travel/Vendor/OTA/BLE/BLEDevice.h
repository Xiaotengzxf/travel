//
//  BLEDevice.h
//  AlexaSDKHost
//
//  Created by ocean on 2017/6/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDeviceDefine.h"

@class BLEManager;


@protocol BLEDeviceDelegate <NSObject>

/**
 当OTAStatus发生变化时触发
 并非实时触发！
 @param status 新的status
 */
-(void)onOTAStatusChanged:(OTAStatus)status;

/**
 传输文件大小发生变化时触发

 @param size 已经传输的数据大小(byte)
 @param totalSize 总共需要传输的数据大小(byte)
 */
-(void)onOTATransmitSize:(NSUInteger)size totalToWriteSize:(NSUInteger)totalSize;

@end

/**
 封装一个Device的信息，包括CBPeripheral，及升级相关的信息
 */
@interface BLEDevice : NSObject<CBPeripheralDelegate> {
    NSMutableDictionary<CBUUID*, CBService*> *_services;
    NSMutableDictionary<CBUUID*, CBCharacteristic*> *_characteristics;
    BLEDeviceNegotiateStep _deviceNegotiateStep;
    
    //for OTA
    NSString* _otaBasePath;
    NSString* _otaFilePath;
    NSFileHandle* _otaFileHandle;
    NSUInteger _otaTotalWrittenBytes; //本次ota总共传输的字节数（包括续传）
    NSUInteger _otaWrittenBytes; //单次传输的字节数
    NSUInteger _otaTotalShouldWriteBytes; //需要传送文件大小的总字节数
    NSRunLoop* _otaWorkingRunloop;
    dispatch_queue_t _otaWorkingQueue;
    BOOL _otaFragmentWrittenFlag;
    BOOL _otaStopFlag;
    int32_t _otaStatus;
    int32_t _otaRetryCount;
    int32_t _otaError;
    //OTA: local save info
    NSString* _otaFile;
    uint64_t _otaOffset;
    NSString* _otaVersion;
}

@property (nonatomic,weak) BLEManager* manager;

@property (nonatomic,strong,readonly) CBPeripheral* peripheral;

@property (nonatomic,weak) id<BLEDeviceDelegate> delegate;

/**
 设备软件版本号
 */
@property (nonatomic,strong) NSString* softVersion;

/**
 设备硬件版本号
 */
@property (nonatomic,strong) NSString* hardVersion;

/**
 当前设备蓝牙协议连接标志
 @value: 为ROVBTConnentState的一些位的组合。每个位上，为1表示该协议连接，为0表示该协议未连接
 */
@property (nonatomic,assign,readonly) ROVBTConnentState btConnectState;


-(instancetype)initWithPeripheral:(CBPeripheral*)peripheral NS_DESIGNATED_INITIALIZER;

-(instancetype)init UNAVAILABLE_ATTRIBUTE;

-(instancetype)new UNAVAILABLE_ATTRIBUTE;

-(void)renewPeriperal:(CBPeripheral*)peripheral;

#pragma mark - property for convenience

-(NSString*)name;

-(NSString*)identifier;

#pragma mark - interaction

-(void)writeAlexaEvent:(NSString*)event;

-(void)writeDeviceEvent:(NSString*)event;

-(void)writeOTAEvent:(NSString*)event;

#pragma mark - phone call event
-(void)onPhoneCallStateChanged:(ROVPhoneCallState)state;

@end
