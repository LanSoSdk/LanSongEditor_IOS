//
//  LSOSaveToFile.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/22.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 保存数据到文件中.
 属于蓝松SDK的辅助功能.
 */
@interface LSOSaveToFile : NSObject

/**
 初始化,
 @param suffix 文件后缀
 @return
 */
-(id)initWithSuffix:(NSString *)suffix;

/**
 初始化
 @param path 完整路径
 @return
 */
-(id)initWithPath:(NSString *)path;



/**
 保存字符串
 */
-(void)saveString:(NSString *)str;

/**
 保存数据

 @param buffer 指针
 @param length 指针对应的长度
 */
-(void)saveData:(void *)buffer length:(int)length;

/**
 保存数据.
 */
-(void)saveData:(NSData *)buffer;
/**
 关闭,并返回保存好的文件路径;
 */
-(NSString *)closeSave;

@end

NS_ASSUME_NONNULL_END
