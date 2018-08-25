//
//  ROVSettingManager.m
//  AlexaSDKHost
//
//  Created by ocean on 2017/8/19.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ROVSettingManager.h"
#import <ZXMoblie/UtilityToolkit.h>
#import "ROVSettingDefine.h"

@interface ROVSettingManager()
@property (nonatomic,strong,readwrite) NSMutableDictionary* currentSetting;
@end

@implementation ROVSettingManager
+ (instancetype)shareManager {
    static ROVSettingManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[ROVSettingManager alloc] init];
    });
    return _shareInstance;
}

-(void)saveSettingValue:(id<NSCopying>)value forKey:(NSString *)title
{
    if (_currentSetting != nil) {
        [_currentSetting setValue:value forKey:title];
        [self syncCurrentSettingToLocal];
    }
}

-(NSDictionary *)loadSettingFromUser:(NSString *)user
{
    return [self loadSettingFromUser:user deviceType:0 deviceUUID:nil];
}

-(NSDictionary *)loadSettingFromUser:(NSString *)user deviceType:(ROVDeviceType)type
{
    return [self loadSettingFromUser:user deviceType:type deviceUUID:nil];
}

-(NSDictionary *)loadSettingFromUser:(NSString *)user deviceType:(ROVDeviceType)type deviceUUID:(NSString *)uuid
{
    NSMutableDictionary* setting = nil;
    NSString* settingPath = [self settingFilePathForUser:user withDeviceType:type deviceUUID:uuid];
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:settingPath isDirectory:&isDir]) {
        if (!isDir) {
            //found the setting file
            setting = [self loadSettingFromPath:settingPath];
            if (setting == nil) {
                setting = [self genDefaultSettingWithDeviceType:type];
            }
        }else{
            [fm removeItemAtPath:settingPath error:nil];
            setting = [self genDefaultSettingWithDeviceType:type];
        }
    }else{
        setting = [self genDefaultSettingWithDeviceType:type];
    }
    
    self.currentUser = user;
    self.currentDeviceType = type;
    self.currentUUID = uuid;
    self.currentSetting = setting;
    
    return setting;
}

#pragma mark - private logic

-(NSString*)deviceType2String:(int)type
{
    return [NSString stringWithFormat:@"%d",type];
}

/**
 当前用户的设置文件夹路径

 @param user 用户id
 @return 文件夹路径
 */
-(NSString*)settingDirPathForUser:(NSString*)user
{
    NSString* cachePath = caches_dir();
    NSString* userPath = [cachePath stringByAppendingPathComponent:user];
    make_sure_dir_exist(userPath);
    return userPath;
}

-(NSString*)settingFilePathForUser:(NSString*)user withDeviceType:(int)type deviceUUID:(NSString*)uuid
{
    if (user == nil || user.length == 0) {
        return nil;
    }
    NSString* dirPath = [self settingDirPathForUser:user];
    NSString* device = [self deviceType2String:type];
    NSString* UUID = uuid == nil ? @"defaul" : uuid;
    dirPath = [dirPath stringByAppendingPathComponent:device];
    make_sure_dir_exist(dirPath);
    NSString* settingPath = [NSString stringWithFormat:@"%@/%@.std",dirPath,UUID];
    return settingPath;
}

#pragma mark - private logic :: default gen
-(NSMutableDictionary*)genDefaultSettingWithDeviceType:(ROVDeviceType)type
{
    NSMutableDictionary *dic;
    switch (type) {
        case ROVDeviceTypeF4:
            dic = [self f4_genDefaultSetting];
            break;
        case ROVDeviceTypeF3:
            
            break;
        case ROVDeviceTypeUnknown:
            
            break;
        default:
            break;
    }
    return dic;
}

-(NSMutableDictionary*)f4_genDefaultSetting
{
    NSMutableDictionary* rtn = [NSMutableDictionary dictionary];
    [rtn setObject:@(1) forKey:kUSKF4WelcomeWord];
    [rtn setObject:@(1) forKey:kUSKF4ScreenLight];
    [rtn setObject:@(0) forKey:kUSKF4ParkingNote];
    [rtn setObject:kUSVF4BuiltInMap forKey:kUSKF4MapApp];
    [rtn setObject:kUSVF4ConnectFM forKey:kUSKF4ConnectionMode];
    return rtn;
}


#pragma mark - private logic :: file serialize
-(void)syncCurrentSettingToLocal
{
    NSString* path = [self settingFilePathForUser:self.currentUser withDeviceType:self.currentDeviceType deviceUUID:self.currentUUID];
    [self wirteSetting:self.currentSetting toPath:path];
}

-(void)wirteSetting:(NSDictionary*)setting toPath:(NSString*)path
{
    if (path == nil || path.length == 0) {
        return;
    }
    NSError* err = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:setting options:0 error:&err];
    if (jsonData == nil || err != nil) {
        NSLog(@"Can't convert setting to Data!!");
    }else{
        [jsonData writeToFile:path atomically:YES];
    }
}

-(NSMutableDictionary*)loadSettingFromPath:(NSString*)path
{
    NSMutableDictionary* rtn = nil;
    NSError* err = nil;
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    do {
        if (jsonData == nil) {
            NSLog(@"Can't load json Data from path %@",path);
            break;
        }
        NSObject* obj = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        if (obj == nil || err != nil) {
            NSLog(@"Can't convert Data to setting!");
            break;
        }
        if (![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"setting data is not a map!");
            break;
        }
        rtn = [obj mutableCopy];
    } while (false);
    return rtn;
}


@end
