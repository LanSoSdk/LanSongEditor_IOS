//
//  SDKDir.h
//  testIOS
//
//  Created by sno on 16/7/22.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKDir : NSObject


    +(NSString *)Path;
/**
 *  创建一个mp4路径(只是路径, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpMp4Path;
/**
 *  创建一个m4a路径(只是路径, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpM4APath;
/**
 *  创建一个m4a路径(只是路径, 没有文件生成)
 *
 *  @return 路径的字符串
 */
+(NSString *)genTmpMp3Path;
@end
