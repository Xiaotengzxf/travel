//
//  BLEDevice.m
//  AlexaSDKHost
//
//  Created by ocean on 2017/6/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BLEDevice.h"
#import "BLEDefine.h"
#import "BLEManager.h"
#import "BLEDevice+OTA.h"


@interface BLEDevice()
@property (nonatomic,strong,readwrite) CBPeripheral* peripheral;
@property (nonatomic,assign,readwrite) ROVBTConnentState btConnectState;
@end

@implementation BLEDevice

-(instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self != nil) {
        self.peripheral = peripheral;
        peripheral.delegate = self;
        _services = [NSMutableDictionary dictionary];
        _characteristics = [NSMutableDictionary dictionary];
        self.btConnectState = ROVBTConnentStateNone;
        [self makeDiscoverIfNeeded];
    }
    return self;
}

-(void)renewPeriperal:(CBPeripheral *)peripheral
{
    if (peripheral == self.peripheral) {
        NSLog(@"Two peripheral is EQUAL!");
        return ;
    }
    self.peripheral = peripheral;
    peripheral.delegate = self;
    [_services removeAllObjects];
    [_characteristics removeAllObjects];
    self.btConnectState = ROVBTConnentStateNone;
    [self makeDiscoverIfNeeded];
}

#pragma mark - property

-(NSString *)name
{
    return _peripheral.name;
}

-(NSString *)identifier
{
    return [_peripheral.identifier UUIDString];
}

#pragma mark - interaction

-(void)writeAlexaEvent:(NSString *)event
{
    [self writeEvent:event toCharacteristic:CBUUID_CHARACTERISTIC_ALEXA];
}

-(void)writeDeviceEvent:(NSString *)event
{
    [self writeEvent:event toCharacteristic:CBUUID_CHARACTERISTIC_DEVICE];
}

-(void)writeOTAEvent:(NSString *)event
{
    //OTA事件跟Device是同一个通道
    [self writeEvent:event toCharacteristic:CBUUID_CHARACTERISTIC_OTA];
}

-(void)writeEvent:(NSString*)event toCharacteristic:(CBUUID*)uuid
{
    if ([event length] == 0) {
        NSLog(@"BLE can't write a blank event!");
        return ;
    }
    CBCharacteristic* chara = [_characteristics objectForKey:uuid];
    if (chara == nil) {
        NSLog(@"BLE not characteristic found for write!");
        return ;
    }
    if (_peripheral == nil) {
        NSLog(@"BLE not device can write( %@ )",event);
        return ;
    }
    NSData* data = [event dataUsingEncoding:NSUTF8StringEncoding];
    CBCharacteristicWriteType type = 0;
    if ( (chara.properties & CBCharacteristicPropertyWrite) != 0 ) {
        type = CBCharacteristicWriteWithResponse;
    }else if( (chara.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0 ) {
        type = CBCharacteristicWriteWithoutResponse;
    }else{
        NSLog(@"BLE chara not support write or writeWithoutResponse!");
        return ;
    }
    @try{
        NSLog(@"BLE >> %@ (%@)", event,type == CBCharacteristicWriteWithResponse ? @"!" : @"?");
        [_peripheral writeValue:data forCharacteristic:chara type:type];
    }
    @catch (NSException* e){
        NSLog(@"BLE write event(%@) exception: %@",event,e);
    }
}

#pragma mark - logic

-(void)notifyAlexaCommandReceived:(NSString*)command
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:BLECommandDidReceivedNotification object:nil userInfo:@{@"c":command}];
}

-(void)onPhoneCallStateChanged:(ROVPhoneCallState)state
{
    NSString* event = nil;
    switch (state) {
        case ROVPhoneCallConnect: {
            event = kDeviceEventPhoneCallOn;
        }break;
        case ROVPhoneCallDisconect: {
            event = kDeviceEventPhoneCallOff;
        }break;
        case ROVPhoneCallDailing:
        case ROVPhoneCallIncomming: {
            event = kDeviceEventPhoneCallRing;
        }break;
        default:
            break;
    }
    if (event != nil) {
        [self writeDeviceEvent:event];
    }
}

#pragma mark - service x charictor

-(void)makeDiscoverIfNeeded
{
    if ([_services count] == 0) {
        [self discoverService:[self interestingServcies]];
    }
}

-(NSArray<CBUUID *> *)interestingServcies
{
    NSMutableArray* rtn = [NSMutableArray array];
    //TODO: add service uuid
    [rtn addObject:CBUUID_SERVICE_MAIN];
    return rtn;
}

-(NSArray<CBUUID *> *)interestingCharacteristicsForService:(CBService*)service
{
    NSMutableArray* rtn = [NSMutableArray array];
    //TODO: add characteristic uuid
    
    [rtn addObject:CBUUID_CHARACTERISTIC_ALEXA];
    [rtn addObject:CBUUID_CHARACTERISTIC_DEVICE];
    [rtn addObject:CBUUID_CHARACTERISTIC_OTA_DATA];
    return rtn;
}

-(void)discoverService:(NSArray<CBUUID *> *)services {
    NSLog(@"start discover service ...");
    [_peripheral discoverServices:services];
}

-(void)discoverCharacteristics:(NSArray*)characteristics forService:(CBService*)service {
    NSLog(@"start discover characteristics for service %@ ...",service);
    [_peripheral discoverCharacteristics:characteristics forService:service];
}

#pragma mark - peripheral delegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error == nil) {
        for (CBService *service in peripheral.services)
        {
            NSArray* charsToFind = [self interestingCharacteristicsForService:service];
            [self discoverCharacteristics:charsToFind forService:service];
            
            [_services setObject:service forKey:service.UUID];
        }
    }else{
        NSLog(@"BLE discover service error: %@",error);
        [self.manager onDeviceNegotiationFinished:NO];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error == nil) {
        for (CBCharacteristic* characteristic in service.characteristics) {
            [_characteristics setObject:characteristic forKey:characteristic.UUID];
            
            //test
            NSLog(@"current chara = %@",characteristic.UUID);
            NSLog(@"characteristic permission: 0x%lx",(unsigned long)characteristic.properties);
            if ( (characteristic.properties & CBCharacteristicPropertyNotify) > 0 ) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
            if ([characteristic.UUID isEqual:CBUUID_CHARACTERISTIC_DEVICE]) {
                [self writeDeviceEvent:kDeviceEventIPhone];
                _deviceNegotiateStep = BLEDeviceNegotiateStepPhoneTypeSent;
            }
        }
    }else{
        NSLog(@"BLE discover character error: %@",error);
        [self.manager onDeviceNegotiationFinished:NO];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
    NSLog(@"enable notify result: ");
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"OK");
    }
    
}

//This method is invoked after a readValueForCharacteristic: call, or upon receipt of a notification/indication.
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    NSString* command = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    //TODO: check command is valid.
    NSLog(@"BLE << %@",command);
    
    if ([command hasPrefix:@"ota:"]) {
        [self ota_peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
    else if([command hasPrefix:kDeviceEventHFPConnectState]) {
        NSArray* comps = [command componentsSeparatedByString:@":"];
        if ([comps count] == 3) {
            int state = [[comps objectAtIndex:2] intValue];
            if (state == 0) {
                //mBitOp_ClearFlag(self.btConnectState, ROVBTConnentStateHFP);
            }else{
                //mBitOp_SetFlag(self.btConnectState, ROVBTConnentStateHFP);
            }
        }
    }
    else if([command hasPrefix:kDeviceEventA2DPConnectState]) {
        NSArray* comps = [command componentsSeparatedByString:@":"];
        if ([comps count] == 3) {
            int state = [[comps objectAtIndex:2] intValue];
            if (state == 0) {
                //mBitOp_ClearFlag(self.btConnectState, ROVBTConnentStateA2DP);
            }else{
                //mBitOp_SetFlag(self.btConnectState, ROVBTConnentStateA2DP);
            }
        }
        
    }else{
        //notify outside
        [self notifyAlexaCommandReceived:command];
    }
}

//This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{    
    if ([characteristic.UUID isEqual:CBUUID_CHARACTERISTIC_DEVICE]) {
        if (_deviceNegotiateStep == BLEDeviceNegotiateStepPhoneTypeSent) {
            NSString* carkit = [self.manager onDeviceNeedCarkitInfo];
            if ([carkit isEqualToString:@"yes"]) {
                [self writeDeviceEvent:kDeviceEventHasCarkit];
            }else{
                [self writeDeviceEvent:kDeviceEventNoCarkit];
            }
            _deviceNegotiateStep = BLEDeviceNegotiateStepCarkitSent;
        }else if(_deviceNegotiateStep == BLEDeviceNegotiateStepCarkitSent) {
#ifdef dSendTimeStamp
            NSDate *gtmDate = [NSDate date];
            NSTimeZone *localZone = [NSTimeZone localTimeZone];
            NSInteger interval = [localZone secondsFromGMTForDate:gtmDate];
            NSDate *localDate = [gtmDate dateByAddingTimeInterval:interval];
            NSString* timestamp = [NSString stringWithFormat:@"device:t:%.lf",[localDate timeIntervalSince1970]];
            [self writeDeviceEvent:timestamp];
            _deviceNegotiateStep = BLEDeviceNegotiateStepTimestamp;
        }else if(_deviceNegotiateStep == BLEDeviceNegotiateStepTimestamp) {
#endif
            _deviceNegotiateStep = BLEDeviceNegotiateStepFinished;
            
            //mBitOp_SetFlag(self.btConnectState, ROVBTConnentStateBLE);
            
            [self.manager onDeviceNegotiationFinished:YES];
            
        }else{
            [self ota_peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
        }
    } else if ([characteristic.UUID isEqual:CBUUID_CHARACTERISTIC_OTA_DATA]) {
        [self ota_peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    } else {
    }
}

#pragma mark - setter
-(void)setBtConnectState:(ROVBTConnentState)btConnectState
{
    if (_btConnectState == btConnectState) {
        return ;
    }
    _btConnectState = btConnectState;
    [[NSNotificationCenter defaultCenter] postNotificationName:BTDeviceConnectStateChangedNotification object:nil userInfo:@{@"d":self}];
}

@end
