//
//  LanSongDebug.h
//  LanSongEditorFramework
//
//  Created by sno on 24/11/2017.
//  Copyright © 2017 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanSongDebug : NSObject
/**
 打印出一些log信息.
 比如常见的,当前类有没有被释放: xxx dealloc;
 */
+(void)setOutLog:(BOOL)is;
/**
 是否要打印一个信息
 */
+(BOOL)isOutLog;

@end
