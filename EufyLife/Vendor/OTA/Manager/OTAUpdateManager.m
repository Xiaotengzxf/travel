//
//  OTAUpdateManager.m
//  AlexaSDKHost
//
//  Created by snake on 19/08/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

#import "OTAUpdateManager.h"
#import "BLEManager.h"
#import <ZXMoblie/ZXMoblie.h>
//#import "SSZipArchive.h"
//#import "BluetoothDeviceF4.h"
//#import "BluetoothDeviceF4+OTA.h"
#import "RVBluetoothDeviceF3.h"

#define LogTag @"OTAUpdate"

@interface OTAUpdateManager ()<NSURLSessionDownloadDelegate,BLEDeviceDelegate>
@property (nonatomic, copy) NSString *fileMd5;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) long long fileSize;

@end

@implementation OTAUpdateManager

+ (instancetype)sharedManager {
    static OTAUpdateManager* theManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theManager = [[OTAUpdateManager alloc] init];
    });
    return theManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleOTATransferStateProgress:) name:kNFBLEOTATransferProgress object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleOTATransferStateChange:) name:kNFBLEOTATransferStateChange object:nil];
    }
    return self;
}


//"full_package" =     {
//    "file_md5" = 189e6f3139f02b1f75fcd5ee1e494af5;
//    "file_name" = "roav%2Fd554aa53-80b6-4a1d-8559-1ad7bbbaf1cb_ota.zip";
//    "file_path" = "http://roavcam-ci.s3-us-west-2.amazonaws.com/roav%2Fd554aa53-80b6-4a1d-8559-1ad7bbbaf1cb_ota.zip";
//    "file_size" = 10476821;
//};
- (void)fetchOTAFilesInfo {
//    NSString *otaVersion = [[BLEManager sharedManager] currentDevice].softVersion;
//    [BLEManager sharedManager].currentDevice.delegate = self;
//    NSString *otaVersion = ((BluetoothDeviceF4 *)[[BluetoothManager shareManager] currentDevice]).softVersion;
    NSString *otaVersion = nil;
    if (![otaVersion isValidString]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fetchOTAFilesInfoFail:)]) {
            [self.delegate fetchOTAFilesInfoFail:nil];//error为nil代表缺少本地版本号
        }
        OACLog_Error(LogTag, @"fetchOTAFilesInfo-Error-missing local version number");
        return;
    }
    
    NSArray *array = [otaVersion componentsSeparatedByString:@"."];
    long long version = [array[0] integerValue]*1000000 + [array[1] integerValue]*1000 + [array[2] integerValue];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString: @""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"POST";
    //sdd 暂且写死，后续调整为参数动态获取
    NSDictionary *param = @{@"app_name":@"AnkerRoavCam",
                            @"app_version":[NSNumber numberWithLongLong:version],
                            @"current_version_name":@"RoavC1_SW_V4.0",
                            @"device_type":@"RoavF4",
                            @"roavcam_sn":@"f4_test"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *fullPackageDic = [dic objectForKey:@"full_package"];
            OACLog_Info(LogTag, @"full_package-%@",fullPackageDic);
            _fileMd5 = [fullPackageDic objectForKey:@"file_md5"];
            _fileName = [fullPackageDic objectForKey:@"file_name"]; 
            _filePath = [fullPackageDic objectForKey:@"file_path"];
            _fileSize = [[fullPackageDic objectForKey:@"file_size"] longLongValue];
            if (self.delegate && [self.delegate respondsToSelector:@selector(fetchOTAFilesInfoSuccess:)]) {
                [self.delegate fetchOTAFilesInfoSuccess:fullPackageDic];
            }
        } else {
            OACLog_Error(LogTag, @"fetchOTAFilesInfo-Error-%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(fetchOTAFilesInfoFail:)]) {
                [self.delegate fetchOTAFilesInfoFail:error];
            }
        }
        
    }];
    [dataTask resume];
}

- (BOOL)checkOTAUpdateIfNeeded {
//    return [[BLEManager sharedManager] checkOTAIfNeeded];
//    return [((BluetoothDeviceF4 *)[[BluetoothManager shareManager] currentDevice]) checkOTAIfNeeded];
    return YES;
}

- (void)downloadOTAFiles {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_fileName];
    NSData *md5Data = [self md5OfFile:path];
    NSString *md5Str = [self convertDataToHexStr:md5Data];
    if ([md5Str isEqualToString:_fileMd5]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadOTAFilesSuccess:)]) {
            [self.delegate downloadOTAFilesSuccess:path];
        }
        OACLog_Info(LogTag, @"The files exists locally,don't need to download.");
        return;
    }
    NSURL *url = [NSURL URLWithString:_filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
    OACLog_Info(LogTag, @"start download.");
}

- (void)doStartOTAUpdate {
//    [[BLEManager sharedManager] startOTA];
//    [((BluetoothDeviceF4 *)[[BluetoothManager shareManager] currentDevice]) startOTA];
}

/**
 计算一个文件的md5
 
 @param filePath 文件路径
 @return 文件的md5
 */
- (NSData*)md5OfFile:(NSString*)filePath { 
    NSData* rtn = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    if(data != nil) {
        rtn = [data md5];
    }
    return rtn;
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

#pragma mark -NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadOTAFilesProgress:)]) {
        //[self.delegate downloadOTAFilesProgress: 1.0 * totalBytesWritten/totalBytesExpectedToWrite];
    }
}

/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s",__func__);
}

/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_fileName];
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadOTAFilesSuccess:)]) {
        [self.delegate downloadOTAFilesSuccess:fullPath];
    }
    OACLog_Error(LogTag, @"download success.");
}

/**
 *  请求结束
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        OACLog_Error(LogTag, @"download fail.");
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadOTAFilesFail:)]) {
            [self.delegate downloadOTAFilesFail:error];
        }
    }
}


#pragma mark -BLEDeviceDelegate
- (void)onOTATransmitSize:(NSUInteger)size totalToWriteSize:(NSUInteger)totalSize {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadOTAFilesProgress:)]) {
        //[self.delegate uploadOTAFilesProgress:(float)size/totalSize];
    }
}

- (void)onOTAStatusChanged:(OTAStatus)status {
    if (status == OTAStatusStopped) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(uploadOTAFilesFail)]) {
            [self.delegate uploadOTAFilesFail];
        }
    } else if (status == OTAStatusFinished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(uploadOTAFilesSuccess)]) {
            [self.delegate uploadOTAFilesSuccess];
        }
    }
}

- (void)bleOTATransferStateChange:(NSNotification *)notification {
    OTAStatus status = (OTAStatus)[notification.object integerValue];
    [self onOTAStatusChanged:status];
}

- (void)bleOTATransferStateProgress:(NSNotification *)notification {
    NSInteger hasWrite = [notification.object[@"hasWriteBytes"] integerValue];
    NSInteger totalBytes = [notification.object[@"totalBytes"] integerValue];
    [self onOTATransmitSize:hasWrite totalToWriteSize:totalBytes];
}


@end
