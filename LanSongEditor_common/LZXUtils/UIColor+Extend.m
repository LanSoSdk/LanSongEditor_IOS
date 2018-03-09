//
//  UIColor+Extend.m
//  hualala
//
//  Created by Chou Chris on 11-12-25.
//  Copyright (c) 2011年 Gozap. All rights reserved.
//

#import "UIColor+Extend.h"

#define DEFAULT_VOID_COLOR  [UIColor colorWithRed:49/255 green:186/255 blue:138/255 alpha:1.0]

@implementation UIColor (Extend)

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) 
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) 
        return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
