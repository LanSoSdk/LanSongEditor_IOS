//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


#pragma mark - theme colors

+ (UIColor *)themeColor
{
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}


+ (UIColor *)nameColor
{
    return [UIColor colorWithHex:0x087221];
}

+ (UIColor *)titleColor
{
    return [UIColor blackColor];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:217.0/255 green:217.0/255 blue:223.0/255 alpha:1.0];
}

+ (UIColor *)cellsColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)titleBarColor
{
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)contentTextColor
{
    return [UIColor colorWithHex:0x272727];
}


+ (UIColor *)selectTitleBarColor
{
    
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)navigationbarColor
{
    //return [UIColor colorWithHex:0x15A230];//0x009000
    return [UIColor colorWithHex:0xFF4500];
}
+ (UIColor *)selectCellSColor
{
    return [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
}

+ (UIColor *)labelTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)teamButtonColor
{
    return [UIColor colorWithRed:251.0/255 green:251.0/255 blue:253.0/255 alpha:1.0];
}

+ (UIColor *)infosBackViewColor
{
    return [UIColor clearColor];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithHex:0x2bc157];
}

+(UIColor *)lineColorSkyblue
{
    return [UIColor colorWithHex:0x87CEEB];
}

@end
