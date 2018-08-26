//
//  CGPathProducer.m
//
//
//  Created by xietao on 2017/6/13.
//  Copyright © 2017年 xietao3. All rights reserved.
//

#import "CGPathProducer.h"
#import "XTBezierPathProducer.h"

@interface CGPathProducer ()

@end

@implementation CGPathProducer

+ (CGPathRef)createPath:(NSArray<NSValue *> *)controlPoint {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, controlPoint.lastObject.CGPointValue.x, controlPoint.lastObject.CGPointValue.y);
    CGPathAddLineToPoint(path, NULL, controlPoint.firstObject.CGPointValue.x, controlPoint.firstObject.CGPointValue.y);
    
    for (int i = 1; i < controlPoint.count; i++) {
        NSValue *startPointValue = controlPoint[i-1];
        NSValue *endPointValue = controlPoint[i];
        CGPoint startPoint = startPointValue.CGPointValue;
        CGPoint endPoint = endPointValue.CGPointValue;
        
        // 插入两个控制点
        CGFloat diffX = endPoint.x-startPoint.x;
        NSValue *secondPointValue = [NSValue valueWithCGPoint:CGPointMake(startPoint.x+diffX/2.0, startPoint.y)];
        NSValue *thirdPointValue = [NSValue valueWithCGPoint:CGPointMake(startPoint.x+diffX/2.0, endPoint.y)];
        
        // 得到贝塞尔曲线所有的点
        NSArray *bezierPathPoints = [XTBezierPathProducer getBezierPathWithPoints:@[startPointValue,secondPointValue,thirdPointValue,endPointValue]];
        
        // 开始绘画贝塞尔曲线
        for (int j = 1; j < bezierPathPoints.count; j++) {
            NSValue *endPointValue = bezierPathPoints[j];
            CGPathAddLineToPoint(path, NULL, endPointValue.CGPointValue.x, endPointValue.CGPointValue.y);
        }
    }
    return path;
}

@end
