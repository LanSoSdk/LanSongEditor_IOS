//
//  BlazeiceUtils.m
//  lexue
//
//  Created by zhujiajun on 12-9-15.
//  Copyright (c) 2012年 白冰. All rights reserved.
//

#import "BlazeiceUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation BlazeiceUtils

+ (void)showWaiting:(UIView *)view msg:(NSString *)msg
{
    int width = 32, height = 32;
    CGRect frame = CGRectMake(100, 200, 110, 70) ;
    int x = frame.size.width;
    int y = frame.size.height;
    
    frame = CGRectMake((x - width) / 2, (y - height) / 2, width, height);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    frame = CGRectMake((x - 60)/2, (y - height) / 2 + height, 80, 20);
    UILabel *waitingLable = [[UILabel alloc] initWithFrame:frame];
    waitingLable.text = msg == nil? @"载入中..." : msg;
    waitingLable.textColor = [UIColor whiteColor];
    waitingLable.font = [UIFont systemFontOfSize:15];
    waitingLable.backgroundColor = [UIColor clearColor];
    
    frame =  CGRectMake((view.frame.size.width - width) /2, 200, 110, 80) ;//[parent frame];
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.backgroundColor = [UIColor blackColor];
    theView.alpha = 0.7;
    theView.layer.cornerRadius = 6;
    
    [theView addSubview:progressInd];
    [theView addSubview:waitingLable];
    
    [theView setTag:9999];
    [view addSubview:theView];
}

+ (void)hideWaiting:(UIView *)view
{
    [[view viewWithTag:9999] removeFromSuperview];
}

//截图 view
+ (UIImage*) rectScreenshot:(UIView *) theView frameRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [theView.layer renderInContext:context];
         NSLog(@"layer  2222renderInContext>>>>.....");
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

//截图 UIImage
+ (UIImage *)croppedPhoto:(UIImage *)photo frameRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([photo CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

//处理图片变为灰色
+ (UIImage *)getGrayImage:(UIImage *)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    //CGColorSpaceCreateDeviceGray会创建一个设备相关的灰度颜色空间的引用
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

//图片缩放处理 等比例
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    if (image.size.width > 90 && image.size.height >100) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    }else if(image.size.width > 90 && image.size.height < 100){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height)];
    }else if(image.size.width < 90 && image.size.height > 100){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width,image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:nowUTC];
}

+(NSDate *)getStartDate:(NSDate *)startDate{
    NSCalendar *calendarTime = [NSCalendar currentCalendar];
    NSDateComponents *startComps = [calendarTime components:(NSMinuteCalendarUnit)  fromDate:startDate];
    NSInteger startMinute = [startComps minute];
    if (startMinute % 30 == 1) {
        startDate = [NSDate dateWithTimeInterval:-60 sinceDate:startDate];
    }else if (startMinute % 30 == 29){
        startDate = [NSDate dateWithTimeInterval:60 sinceDate:startDate];
    }
    return startDate;
}

+(NSDate *)getEndDate:(NSDate *)endDate{
    NSCalendar *calendarTime = [NSCalendar currentCalendar];
    NSDateComponents *endComps = [calendarTime components:(NSMinuteCalendarUnit)  fromDate:endDate];
    NSInteger endMinute = [endComps minute];
    if (endMinute % 30 == 1) {
        endDate = [NSDate dateWithTimeInterval:-60 sinceDate:endDate];
    }else if (endMinute % 30 == 29){
        endDate = [NSDate dateWithTimeInterval:60 sinceDate:endDate];
    }
    return endDate;
}

+(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end

