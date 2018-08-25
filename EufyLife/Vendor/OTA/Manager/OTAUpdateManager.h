//
//  OTAUpdateManager.h
//  AlexaSDKHost
//
//  Created by snake on 19/08/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol OTAUpdateManagerDelegate <NSObject>

- (void)fetchOTAFilesInfoSuccess:(NSDictionary *)result;
- (void)fetchOTAFilesInfoFail:(NSError *)error;
- (void)downloadOTAFilesProgress:(CGFloat)progress;
- (void)downloadOTAFilesSuccess:(NSString *)filePath;
- (void)downloadOTAFilesFail:(NSError *)error;
- (void)uploadOTAFilesProgress:(CGFloat)progress;
- (void)uploadOTAFilesSuccess;
- (void)uploadOTAFilesFail;

@end

@interface OTAUpdateManager : NSObject
@property (nonatomic, weak) id<OTAUpdateManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void)fetchOTAFilesInfo;
- (BOOL)checkOTAUpdateIfNeeded;
- (void)downloadOTAFiles;
- (void)doStartOTAUpdate;

@end
