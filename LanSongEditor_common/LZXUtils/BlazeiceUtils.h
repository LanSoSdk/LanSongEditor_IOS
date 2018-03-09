//
//  BlazeiceUtils.h
//  lexue
//
//  Created by zhujiajun on 12-9-15.
//  Copyright (c) 2012年 白冰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//static NSString *USERID = @"userId";
//static NSString *PASS= @"pass";

@interface BlazeiceUtils : NSObject


//显示进度滚轮指示器
+ (void)showWaiting:(UIView *)view msg:(NSString *)msg;
+ (void)hideWaiting:(UIView *)view;
//截取区域图片
+ (UIImage*) rectScreenshot:(UIView *) theView frameRect:(CGRect)rect;
//处理图片变为灰色
+ (UIImage *)getGrayImage:(UIImage *)sourceImage;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)croppedPhoto:(UIImage *)photo frameRect:(CGRect)rect;

+(NSString *)getCurrentTime;
+(NSDate *)getStartDate:(NSDate *)startDate;
+(NSDate *)getEndDate:(NSDate *)endDate;
+(AppDelegate *)appDelegate;


@end
