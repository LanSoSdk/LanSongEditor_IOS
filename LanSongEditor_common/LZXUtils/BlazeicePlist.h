//
//  BlazeicePlist.h
//  lexue-teacher
//
//  Created by 白冰 on 13-6-4.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlazeicePlist : NSObject

+ (NSString *)readPlistDataWithKey:(NSString *)key;
+ (NSString *)readUser;
@end
