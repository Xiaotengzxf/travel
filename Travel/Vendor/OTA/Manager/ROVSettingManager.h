//
//  ROVSettingManager.h
//  AlexaSDKHost
//
//  Created by ocean on 2017/8/19.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDeviceDefine.h"
/**
 管理不同设备设置界面用户所保存的值，包括这些值的本地化存取。
 */
@interface ROVSettingManager : NSObject {
    
}
@property (nonatomic,strong) NSString* currentUser;
@property (nonatomic,assign) ROVDeviceType currentDeviceType;
@property (nonatomic,strong) NSString* currentUUID;
@property (nonatomic,strong,readonly) NSMutableDictionary* currentSetting;

+ (instancetype)shareManager;

#pragma mark - save

-(void)saveSettingValue:(id<NSCopying>)value forKey:(NSString*)title;

#pragma mark - load

-(NSDictionary*)loadSettingFromUser:(NSString*)user;

-(NSDictionary*)loadSettingFromUser:(NSString*)user deviceType:(ROVDeviceType)type;

-(NSDictionary*)loadSettingFromUser:(NSString*)user deviceType:(ROVDeviceType)type deviceUUID:(NSString*)uuid;

@end
