//
//  BLEDeviceInfoModel.m
//  AlexaSDKHost
//
//  Created by ocean on 2017/8/8.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BLEDeviceInfoModel.h"
#import <ZXMoblie/UtilityToolkit.h>

@implementation BLEDeviceInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dct
{
    self = [super init];
    if (self) {
        self.uuid = dictionary_get_nsstring(dct, @"u", @"");
        self.name = dictionary_get_nsstring(dct, @"n", nil);
        self.type = dictionary_get_int(dct, @"t", ROVDeviceTypeUnknown);
    }
    return self;
}

-(NSDictionary *)toDictionary
{
    NSMutableDictionary* dct = [NSMutableDictionary dictionary];
    dictionary_set_object(dct, @"u", self.uuid);
    dictionary_set_object(dct, @"n", self.name);
    dictionary_set_object(dct, @"t",@(self.type));
    return dct;
}

@end
