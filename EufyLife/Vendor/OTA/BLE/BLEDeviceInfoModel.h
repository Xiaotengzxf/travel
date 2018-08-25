//
//  BLEDeviceInfoModel.h
//  AlexaSDKHost
//
//  Created by ocean on 2017/8/8.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDeviceDefine.h"

/**
 设备相关信息
 */
@interface BLEDeviceInfoModel : NSObject

@property (nonatomic,strong) NSString* uuid;

@property (nonatomic,strong) NSString* name;

@property (nonatomic,assign) ROVDeviceType type;

-(instancetype)initWithDictionary:(NSDictionary*)dct;

-(NSDictionary*)toDictionary;

@end
