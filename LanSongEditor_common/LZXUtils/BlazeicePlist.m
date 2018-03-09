//
//  BlazeicePlist.m
//  lexue-teacher
//
//  Created by 白冰 on 13-6-4.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import "BlazeicePlist.h"

@implementation BlazeicePlist

+ (NSString *)readPlistDataWithKey:(NSString *)key
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}
+ (NSString *)readUser
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UserType"];
}
@end
