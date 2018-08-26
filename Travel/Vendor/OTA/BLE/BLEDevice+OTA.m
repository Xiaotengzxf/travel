//  BLEDevice+OTA.m
//  AlexaSDKHost
//
//  Created by ocean on 2017/7/22.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BLEDevice+OTA.h"
#import "BLEDefine.h"
#import <ZXMoblie/UtilityToolkit.h>
#import <ZXMoblie/OACLogger.h>
#import <ZXMoblie/NSData+Digest.h>

#define LogTag @"OTA"

#define kTransmitChunkSize 4096
#define kTransmitRetryTime 3

@implementation BLEDevice (OTA)

-(void)queryDeviceVersionInfos
{
    [self writeOTAEvent:kOTAEventQueryVersion];
}

-(void)setOTADirPath:(NSString *)path
{
    //check path
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* iniPath = [path stringByAppendingPathComponent:@"filelist.ini"];
    BOOL valid = YES;
    BOOL isDir = NO;
    if (![fm fileExistsAtPath:iniPath isDirectory:&isDir] || isDir) {
        valid = NO;
    }
    if (valid) {
        _otaBasePath = path;
    }
}

-(void)startOTAProcedure
{
    //2, 开启线程进行
    if (_otaWorkingQueue == NULL) {
        _otaWorkingQueue = dispatch_queue_create("roav.ota.data", 0);
    }
    
    __weak typeof(self) wself = self;
    dispatch_async(_otaWorkingQueue, ^{
        __strong typeof(wself) sself = wself;
        if (sself == nil) {
            //由于self都为nil了，也无法找到delegate了就算了
            return ;
        }
        //2.1, 获取到runloop并设置
        sself->_otaWorkingRunloop = [NSRunLoop currentRunLoop];
        //为了能够在runloop阻塞，需要添加Port
        [sself->_otaWorkingRunloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        
        //2.2，获取到文件总大小，用于填充
        NSString* iniPath = [sself otaFilePath:@"filelist.ini"];
        NSUInteger size = [[sself iniFile:iniPath getValueWithKey:@"size" inSecion:@"[kernel]"] integerValue];
        sself->_otaTotalShouldWriteBytes += size;
        size = [[sself iniFile:iniPath getValueWithKey:@"size" inSecion:@"[updater]"] integerValue];
        sself->_otaTotalShouldWriteBytes += size;
        size = [[sself iniFile:iniPath getValueWithKey:@"size" inSecion:@"[appfs]"] integerValue];
        sself->_otaTotalShouldWriteBytes += size;
        
        
        //2.3, 开始进行流程,先询问是否允许发送
        [sself writeOTAEvent:kOTAEventStart];
        sself.otaStatus = OTAStatusSendStart;
    });
}

-(BOOL)transmitOTADataFile:(NSString*)fileName startOffset:(NSUInteger)offset
{
    BOOL rtn = NO;
    //获取并设置到写入类型
    CBCharacteristic* chara = [_characteristics objectForKey:CBUUID_CHARACTERISTIC_OTA_DATA];
    if (chara == nil) {
        NSLog(@"BLE not characteristic found for write!");
        return rtn;
    }
    CBCharacteristicWriteType type = 0;
    if ( (chara.properties & CBCharacteristicPropertyWrite) != 0 ) {
        type = CBCharacteristicWriteWithResponse;
    }else if( (chara.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0 ) {
        type = CBCharacteristicWriteWithoutResponse;
    }else{
        NSLog(@"BLE chara not support write or writeWithoutResponse!");
        return rtn;
    }
    NSString* filePath = [self otaFilePath:fileName];
    rtn = [self prepareTransmitOTADataFile:filePath startOffset:offset];
    if (rtn) {
        __weak typeof(self) wself = self;
        [self asyncTransmitFileDataWithCharacteristic:chara writeType:type withCallback:^(BOOL res) {
            //4. 发送成功
            __strong typeof(wself) sself = wself;
            if(sself == nil) { return ; }
            if (res) { //成功发送
                if ([fileName isEqualToString:@"filelist.ini"]) {
                    [sself writeOTAEvent:kOTAEventDidSendFileList];
                }else if([fileName isEqualToString:@"kernel"]) {
                    [sself writeOTAEvent:kOTAEventDidSendKernel];
                    sself.otaStatus = OTAStatusWillSendUpdater;
                }else if([fileName isEqualToString:@"updater"]) {
                    [sself writeOTAEvent:kOTAEventDidSendUpdater];
                    sself.otaStatus = OTAStatusWillSendAppfs;
                }else if([fileName isEqualToString:@"appfs"]) {
                    [sself writeOTAEvent:kOTAEventDidSendAppfs];
                    sself.otaStatus = OTAStatusWillSendReboot;
                    //接着等待设备传送软件版本号
                }
            }else{ //失败发送
                
            }
        }];
    }
    return rtn;
}

-(void)abortOATDataTransmit
{
    _otaStopFlag = YES;
}

-(void)ota_peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error == nil) {
        _otaFragmentWrittenFlag = YES;
    } else {
        NSLog(@"OTA didWriteValue-error-%@",error);
    }
    if (_otaWorkingRunloop != nil) {
        CFRunLoopRef ref = [_otaWorkingRunloop getCFRunLoop];
        if (CFRunLoopIsWaiting(ref)) {
            CFRunLoopStop(ref);
            //为何不用CFRunLoopWakeup呢？参考：
            //https://stackoverflow.com/questions/11205654/cfrunloopwakeup-doesnt-work
        }
    }
}

-(void)ota_peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //这里在dispatch之后再取一次，不知是否会有问题，先这样
    NSString* command = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSLog(@"OTA coammnd = %@",command);
    
    if ([command hasPrefix:kOTACommandHardVersionPrefix]) {
        NSRange r = [command rangeOfString:kOTACommandHardVersionPrefix];
        NSString* version = [command substringFromIndex:r.location+r.length];
        self.hardVersion = version;
    } else if([command hasPrefix:kOTACommandSoftVersionPrefix]) {
        if (self.otaStatus == OTAStatusWillSendReboot) {
            //如果处于等待reboot状态，命令其reboot，完成升级！
            [self writeOTAEvent:kOTAEventReboot];
            self.otaStatus = OTAStatusFinished;
        }else{
            NSRange r = [command rangeOfString:kOTACommandSoftVersionPrefix];
            NSString* version = [command substringFromIndex:r.location+ r.length];
            self.softVersion = version; 
        }
    } else if([command isEqualToString:kOTACommandReject]) {
        self.otaStatus = OTAStatusStopped;
        self.otaError = OTAErrorDeviceRejected;
    } else if([command isEqualToString:kOTACommandReady]) {
        OTAStatus otaStatus = self.otaStatus;
        //3, 开始发送正式文件
        if (otaStatus == OTAStatusSendStart) {
            [self writeOTAEvent:kOTAEventWillSendFileListMD5];
            self.otaStatus = OTAStatusWillSendMD5Data;
        } else if (otaStatus == OTAStatusWillSendMD5Data) {
            //先传md5，再传实际文件内容
            NSData* md5Data = [self md5OfFile:[self otaFilePath:@"filelist.ini"]];
            self.otaStatus = OTAStatusSendingMD5Data;
            //比较短，就直接发了
            CBCharacteristic* wchara = [_characteristics objectForKey:CBUUID_CHARACTERISTIC_OTA_DATA];
            CBCharacteristicWriteType type = 0;
            if ( (wchara.properties & CBCharacteristicPropertyWrite) != 0 ) {
                type = CBCharacteristicWriteWithResponse;
            }else if( (wchara.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0 ) {
                type = CBCharacteristicWriteWithoutResponse;
            }else{
                NSLog(@"BLE chara not support write or writeWithoutResponse!");
                return;
            }
            NSLog(@"OTA md5Data-%@",md5Data);
            BOOL send = [self writeChunkData:md5Data toCharacteristic:wchara writeType:type];
            if (!send) {
                self.otaStatus = OTAStatusStopped;
                self.otaError = OTAErrorTransmitFail;
            } else {
                [self writeOTAEvent:kOTAEventDidSendFileListMD5];
            }
        } else if (otaStatus == OTAStatusWillSendFileList) {
            
            BOOL res = [self transmitOTADataFile:@"filelist.ini" startOffset:0];
            if (!res) {
                self.otaStatus = OTAStatusStopped;
                self.otaError = OTAErrorTransmitFail;
            }
        }
    } else if ([command isEqualToString:kOTACommandMD5Retry]) {
        [self writeOTAEvent:kOTAEventWillSendFileList];
        self.otaStatus = OTAStatusWillSendFileList;
    } else if ([command isEqualToString:kOTACommandMD5Next]) {
        [self writeOTAEvent:kOTAEventWillSendKernel];
        self.otaStatus = OTAStatusWillSendKernel;
    } else if ([command isEqualToString:kOTACommandSkip]) {
        if (self.otaStatus == OTAStatusWillSendKernel) {
            [self writeOTAEvent:kOTAEventWillSendUpdater];
            self.otaStatus = OTAStatusWillSendUpdater;
        } else if (self.otaStatus == OTAStatusWillSendUpdater) {
            [self writeOTAEvent:kOTAEventWillSendAppfs];
            self.otaStatus = OTAStatusWillSendAppfs;
        } else if (self.otaStatus == OTAStatusWillSendAppfs) {
            self.otaStatus = OTAStatusWillSendReboot;
        }
    } else if ([command isEqualToString:kOTACommandOK]) {
        if (self.otaStatus == OTAStatusWillSendKernel) {
            [self writeOTAEvent:kOTAEventWillSendKernel];
        } else if(self.otaStatus == OTAStatusWillSendUpdater) {
            [self writeOTAEvent:kOTAEventWillSendUpdater];
        } else if(self.otaStatus == OTAStatusWillSendAppfs) {
            [self writeOTAEvent:kOTAEventWillSendAppfs];
        }
    } else if ([command isEqualToString:kOTACommandFail]) {
        if (self.otaStatus == OTAStatusWillSendKernel) {
            [self writeOTAEvent:kOTAEventWillSendFileList];
            self.otaStatus = OTAStatusWillSendFileList;
        } else if(self.otaStatus == OTAStatusWillSendUpdater) {
            [self writeOTAEvent:kOTAEventWillSendKernel];
            self.otaStatus = OTAStatusWillSendKernel;
        } else if(self.otaStatus == OTAStatusWillSendAppfs) {
            [self writeOTAEvent:kOTAEventWillSendUpdater];
            self.otaStatus = OTAStatusWillSendUpdater;
        } else if (self.otaStatus == OTAStatusWillSendReboot) {
            [self writeOTAEvent:kOTAEventWillSendAppfs];
            self.otaStatus = OTAStatusWillSendAppfs;
        }
    } else if ([command isEqualToString:kOTACommandWait]) {
        
    } else {
        //接下来一般是偏移信息
        //先取出文件大小，以及设备回复的偏移值
        NSString* comp = [command componentsSeparatedByString:@":"][1];
        if ([self isPureInt:comp]) { //确定为偏移量
            NSUInteger offset = [comp integerValue]; 
            NSString* iniFilePath = [self otaFilePath:@"filelist.ini"];
            NSUInteger fileSize = 0;
            NSString* target = nil;
            if (self.otaStatus == OTAStatusWillSendKernel) {
                NSString* sizeValue = [self iniFile:iniFilePath getValueWithKey:@"size" inSecion:@"[kernel]"];
                fileSize = [sizeValue integerValue];
                target = @"kernel";
            } else if(self.otaStatus == OTAStatusWillSendUpdater) {
                NSString* sizeValue = [self iniFile:iniFilePath getValueWithKey:@"size" inSecion:@"[updater]"];
                fileSize = [sizeValue integerValue];
                target = @"updater";
            } else if(self.otaStatus == OTAStatusWillSendAppfs) {
                NSString* sizeValue = [self iniFile:iniFilePath getValueWithKey:@"size" inSecion:@"[appfs]"];
                fileSize = [sizeValue integerValue];
                target = @"appfs";
            }
            //判断offset是否比fileSize大？
            if (offset == fileSize) {
                OACLog_Debug(LogTag, @"Skip transmit file %@ for offset already reach file size",target);
                if (self.otaStatus == OTAStatusWillSendKernel) {
                    [self writeOTAEvent:kOTAEventWillSendUpdater];
                    self.otaStatus = OTAStatusWillSendUpdater;
                } else if(self.otaStatus == OTAStatusWillSendUpdater) {
                    [self writeOTAEvent:kOTAEventWillSendAppfs];
                    self.otaStatus = OTAStatusWillSendAppfs;
                } else if(self.otaStatus == OTAStatusWillSendAppfs) {
                    self.otaStatus = OTAStatusWillSendReboot;
                    //等待对方发送软件版本号过来
                }
            } else if (offset > fileSize) {
                OACLog_Debug(LogTag, @"error:offset:%u>fileSize:%u",offset,fileSize);
            } else {
                OACLog_Debug(LogTag, @"OTA Will transimit file %@ from offset %u",target,offset);
                [self transmitOTADataFile:target startOffset:offset];
            }
        }
    }
    
}

- (BOOL)isPureInt:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - private logic

-(BOOL)prepareTransmitOTADataFile:(NSString *)filePath startOffset:(NSUInteger)offset
{
    BOOL rtn = NO;
    do {
        NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if (![fm fileExistsAtPath:filePath isDirectory:&isDir] || isDir) {
            break ;
        }
        
        NSUInteger fileSize = [[fm attributesOfItemAtPath:filePath error:nil][NSFileSize] unsignedIntegerValue];
        if (offset >= fileSize) {
            break ;
        }
        
        NSError* err = nil;
        _otaFileHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:&err];
        if (_otaFileHandle == nil || err) {
            break ;
        }
        
        [_otaFileHandle seekToFileOffset:offset];
        _otaTotalWrittenBytes = offset; // 初始化总写入为起始偏移值
        _otaWrittenBytes = 0;
        rtn = YES;
        NSLog(@"OTA file transmit set file %@ offset to %lu",filePath,offset);
    } while (false);
    return rtn;
}

///**
// 用BLE传输一个文件到设备上
// 此方法默认在调用时，_otaFileHandle,_otaWrittenBytes,_otaTotalWrittenBytes都已经设置到正常状态
// */
-(void)asyncTransmitFileDataWithCharacteristic:(CBCharacteristic*)characteristic writeType:(CBCharacteristicWriteType)type withCallback:(void (^)(BOOL res))callback
{
    __weak typeof(self) wself = self;
    dispatch_async(_otaWorkingQueue, ^{
        __strong typeof(wself) sself = wself;
        if (sself == nil) {
            if (callback) {
                callback(NO);
            }
            return;
        }
        //每次都设置，因为可能queue底层利用的线程并非同一个
        sself->_otaWorkingRunloop = [NSRunLoop currentRunLoop];
        //为了能够在runloop阻塞，需要添加Port
        [sself->_otaWorkingRunloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        NSLog(@"OTA start file transmit");
        //循环读取从offset开始的一小段数据写入直到停止或写完
        BOOL rtn = YES;
        NSData* chunk = [sself->_otaFileHandle readDataOfLength:kTransmitChunkSize];
        while([chunk length] > 0 && !sself->_otaStopFlag) {
            BOOL written = [sself writeChunkData:chunk toCharacteristic:characteristic writeType:type];
            if (written) {
                [sself->_otaFileHandle seekToFileOffset:sself->_otaTotalWrittenBytes];
                chunk = [sself->_otaFileHandle readDataOfLength:kTransmitChunkSize];
                
                //通知外部进度
                if ([sself.delegate respondsToSelector:@selector(onOTATransmitSize:totalToWriteSize:)]) {
                    [sself.delegate onOTATransmitSize:sself->_otaTotalWrittenBytes totalToWriteSize:sself->_otaTotalShouldWriteBytes];
                }
                
            }else{
                rtn = NO;
                break;
            }
        }
        NSLog(@"OTA end file transmit result = %@",rtn ? @"YES" : @"NO");
        if (callback) {
            callback(rtn);
        }
    });
}


-(BOOL)writeChunkData:(NSData*)chunk toCharacteristic:(CBCharacteristic*)characteristic writeType:(CBCharacteristicWriteType)type
{
    BOOL rtn = YES;
    if ([chunk length] == 0) {
        return rtn;
    }
    NSLog(@"OTA chunk.size-%lu",(unsigned long)chunk.length);
    NSUInteger fragmentMaxSize = 20;
    NSUInteger shouldWritten = [chunk length];
    NSUInteger written = 0;
    while(written < shouldWritten && !_otaStopFlag) {
        NSUInteger fragmentSize = (shouldWritten - written) < fragmentMaxSize ? (shouldWritten - written) : fragmentMaxSize;
        NSData* fragment = [chunk subdataWithRange:NSMakeRange(written, fragmentSize)];
//        NSLog(@"OTA fragment.size-%lu",(unsigned long)fragment.length);
        _otaFragmentWrittenFlag = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //test print
//            NSString* str = [[NSString alloc] initWithData:fragment encoding:NSUTF8StringEncoding];
//            NSLog(@">>>> %@",str);
            @try {
                [self.peripheral writeValue:fragment forCharacteristic:characteristic type:type];
            }
            @catch (NSException* e) {
                //TODO:
                NSLog(@"OTA write data fail!!");
            }
        });
        if (type == CBCharacteristicWriteWithoutResponse) {
            //如果是无响应的，就休息一会儿，并认为发送成功
            [NSThread sleepForTimeInterval:0.02]; 
            _otaFragmentWrittenFlag = YES;
        }else{
            //如果是有响应的，直接等待到响应确认
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:10];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];
        }
        //认为OK
        if (_otaFragmentWrittenFlag) {
            written += fragmentSize;
            _otaTotalWrittenBytes += fragmentSize;
            _otaWrittenBytes += fragmentSize;
            _otaRetryCount = 0;
        }else{
            //是否重试？
            NSLog(@"OTA found fragment write FAIL!");
            if (_otaRetryCount < kTransmitRetryTime) {
                _otaRetryCount += 1;
                written -= fragmentSize;
            } else {
                rtn = NO;
            }
            break;
        }
    }
    return rtn;
}

-(NSString*)otaInfoKey 
{
    return [NSString stringWithFormat:@"%@_%@",USER_DEFAULT_KEY_DEVICE_OTA_INFO,self.identifier];
}

-(NSString*)otaFilePath:(NSString*)fileName
{
    return [_otaBasePath stringByAppendingPathComponent:fileName];
}


/**
 从ini文件中读取某个项目的信息

 @param path 文件路径
 @param key 项目的key
 @param section 项目的section
 @return 读取到的值。如果section不存在或者key在section中不存在，返回nil
 */
-(NSString*)iniFile:(NSString*)path getValueWithKey:(NSString*)key inSecion:(NSString*)section
{
    NSString* rtn = nil;
    do {
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSData* target = [section dataUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [data rangeOfData:target options:NSDataSearchBackwards range:NSMakeRange(0, [data length])];
        if (range.location == NSNotFound) {
            break;
        }
        //get all of the data after mark
        NSUInteger offset = range.location+range.length;
        NSString* text = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(offset, [data length]-offset)] encoding:NSUTF8StringEncoding];
        NSArray* lines = [text componentsSeparatedByString:@"\n"];
        for (NSString* line in lines) {
            NSString* ll = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray* comps = [ll componentsSeparatedByString:@"="];
            if ([comps count] != 2) {
                continue;
            }
            if ([comps[0] isEqualToString:key]) {
                rtn = comps[1];
                break;
            }
        }
    } while (false);
    return rtn;
}

/**
 比较ini文件中的版本号和固件版本号并决定是否需要升级

 @return YES：需要升级
 */
-(BOOL)checkUpdateIfNeed
{
    //1.1, 获取到文件夹中升级文件的版本
    NSString* iniFilePath = [self otaFilePath:@"filelist.ini"];
    NSString* iniVersion = [self iniFile:iniFilePath getValueWithKey:@"new_ver" inSecion:@"[version]"];
    NSLog(@"iniVersion = %@",iniVersion);
    
    NSArray* verIni = [iniVersion componentsSeparatedByString:@"."];
    NSArray* verSoft = [self.softVersion componentsSeparatedByString:@"."];
    int update = 0;
    if ([verIni count] > 0 && [verSoft count] > 0) {
        int v1 = [[verIni firstObject] intValue];
        int v2 = [[verSoft firstObject] intValue];
        if (v1 > v2) {
            update |= 1;
        }
    }
    if ([verIni count] > 1 && [verSoft count] > 1) {
        int v1 = [[verIni objectAtIndex:1] intValue];
        int v2 = [[verSoft objectAtIndex:1] intValue];
        if (v1 > v2) {
            update |= 1;
        }
    }
    if ([verIni count] > 2 && [verSoft count] > 2) {
        int v1 = [[verIni objectAtIndex:2] intValue];
        int v2 = [[verSoft objectAtIndex:2] intValue];
        if (v1 > v2) {
            update |= 1;
        }
    }
    
    if (update != 1) {
        OACLog_Info(LogTag, @"no update is need!");
        self.otaStatus = OTAStatusFinished;
        self.otaError = OTAErrorNoNeed;
    }
    return update == 1;
}

/**
 计算一个文件的md5

 @param filePath 文件路径
 @return 文件的md5
 */
-(NSData*)md5OfFile:(NSString*)filePath
{
    NSData* rtn = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    if(data != nil) {
        rtn = [data md5];
    }
    return rtn;
}

-(void)notifyOTAStatusChanged
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doNotifyOTAStatusChanged) object:nil];
    [self performSelector:@selector(doNotifyOTAStatusChanged) withObject:nil afterDelay:0.005 inModes:@[NSRunLoopCommonModes]];
}

-(void)doNotifyOTAStatusChanged
{
    if ([self.delegate respondsToSelector:@selector(onOTAStatusChanged:)]) {
        [self.delegate onOTAStatusChanged:self.otaStatus];
    }
}

#pragma mark - getter x setter
-(OTAStatus)otaStatus
{
    return _otaStatus;
}

-(void)setOtaStatus:(OTAStatus)otaStatus
{
    if (_otaStatus == otaStatus) {
        return ;
    }
    _otaStatus = otaStatus;
    [self notifyOTAStatusChanged];  
}

-(OTAError)otaError
{
    return _otaError;
}

-(void)setOtaError:(OTAError)otaError
{
    if (_otaError == otaError) {
        return ;
    }
    _otaError = otaError;
}

@end
