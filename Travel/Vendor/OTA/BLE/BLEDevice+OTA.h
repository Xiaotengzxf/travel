//
//  BLEDevice+OTA.h
//  AlexaSDKHost
//
//  Created by ocean on 2017/7/22.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BLEDevice.h"
#import "BLEDeviceDefine.h"



/**
 设备OTA相关的方法
 */
@interface BLEDevice (OTA)

@property (nonatomic,assign) OTAStatus otaStatus;

@property (nonatomic,assign) OTAError otaError;

#pragma mark - ota infos


/**
 查询设备软件，硬件版本信息
 */
-(void)queryDeviceVersionInfos;

/**
 设置ota操作基本目录

 @param path 目录路径
 */
-(void)setOTADirPath:(NSString*)path;


-(BOOL)checkUpdateIfNeed;

/**
 开始ota操作,各种结果将在回调中体现
 */
-(void)startOTAProcedure;


#pragma mark - data transmit

/**
 传输指定的文件到设备
 此方法返回仅表示数据传输开始，并不代表文件的真正传输成功！
 @param fileName 文件名称（不是完整文件路径！）
 @param offset 起始偏移
 @return YES:成功开始进行传输数据；NO:无法开始传输数据
 */
-(BOOL)transmitOTADataFile:(NSString*)fileName startOffset:(NSUInteger)offset;

/**
 终止文件传输
 终止传输是一个异步操作，此调用返回不能代表传输已经停止。
 */
-(void)abortOATDataTransmit;

/**
 CBPeripheral回调方法针对ota通道的处理，此方法由主类中同名方法进行dispatch

 @param peripheral 外设
 @param characteristic 特征值，此值应该为OTA通道的特征值
 @param error 写入错误
 */
-(void)ota_peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

/**
 CBPeripheral回调方法针对ota通道的处理，此方法由主类中同名方法进行dispatch

 @param peripheral 外设
 @param characteristic 特征值，此值应该为OTA事件通道的特征值
 @param error 写入错误
 */
-(void)ota_peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end
