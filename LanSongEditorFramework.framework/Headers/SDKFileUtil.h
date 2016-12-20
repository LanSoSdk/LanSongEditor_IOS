//
//  SDKFileUtil.h
//  testIOS
//
//  Created by sno on 16/7/22.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKFileUtil : NSObject

/**
 *  拷贝资源文件到目标文件夹
 *
 *  @param name   资源名字
 *  @param fix    后缀
 *  @param dstDir 目标文件夹
 *
 *  @return 拷贝成功,返回目标文件名;失败返回NULL
 */
+(NSString *) copyAssetFile:(NSString *)name withSubffix:(NSString *)fix dstDir:(NSString *)dstDir;

/**
 *  拷贝文件
 *
 *  @param sourcePath 源路径
 *  @param toPath     目标文件路径(包含目标文件名)
 *
 *  @return 如果拷贝成功,返回YES,失败返回NO, (可能是内存不足导致失败)
 */
+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath;
/**
 *  判断文件是否存在
 *
 *  @param str 文件路径
 *
 *  @return 存在返回YES,不存在返回NO
 */
+ (BOOL) fileExist:(NSString *)str;

/**
 *  判断文件数组是否存在, 需要array中的所有都是NSString类型的数据.
 *
 *  @param array 里面都是 NSString的数组.
 *
 *  @return 存在返回YES,不存在返回NO
 */
+ (BOOL) fileArrayExist:(NSMutableArray *)array;
/**
 * @brief 创建文件夹
 *
 * @param createDir 创建文件夹路径
 * @
 */
+ (void)createDir:(NSString *)createDir;
//在指定的文件夹下.
/**
 *  生成这个文件名字, 并不真正在文件夹里创建文件
 *
 *  @param dir    文件夹全路径, 可以是NSHome
 *  @param suffix 后缀名字
 *
 *  @return 返回创建好的文件路径字符串.
 */
+ (NSString *) genNewFileName:(NSString *)dir suffix:(NSString *)suffix;

/**
 *  在默认的文件夹下创建一个路径字符串,
 *
 *  @param suffix 后缀名字
 *
 *  @return  返回创建好的文件路径字符串.
 */
+ (NSString *) genFileNameWithSuffix:(NSString *)suffix;

/**
 *  从文件路劲中获取文件名字.
 *
 *  @param filePath 文件路径
 *
 *  @return 字符串名字或NULL;
 */
+ (NSString *)getfileName:(NSString *)filePath;
/**
 *  删除文件,
 *
 *  @param filepath 文件的完整路径
 */
+(void)deleteFile:(NSString *)filepath;
/**
 *  删除文件夹(这里仅仅是删除文件夹里的所有文件,并不删除文件夹名字)
 *
 *  @param dir 文件夹路径
 */
+(void)deleteDir:(NSString *)dir;


/**
 *  返回SDK默认的文件夹, 默认是当前APP的NSDocumentDirectory下创建一个lansongBox文件夹,然后返回.
 *
 *  @return 文件夹路径,
 */
+(NSString *)Path;
/**
 *  在默认的路径中,创建一个mp4路径(只是路径字符串, 没有文件生成)
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

/**
 *
 *  在当前app下Documents文件夹里,创建一个指定文件名的路径
 *  @param filename 返回该路径的字符串(只是生成一个字符串, 没有真正生成文件)
 *
 *  @return 路径字符串
 */
+(NSString *)genFilePathWithName:(NSString *)filename;

/**
 *  把URL转换为 实际的路径字符串
 *
 *  @param url
 *
 *  @return
 */
+(NSString *)urlToFileString:(NSURL *)url;

/**
 *  把字符串绝对路径, 转换为 URL类型路径
 *
 *  @param path
 *
 *  @return
 */
+(NSURL *)filePathToURL:(NSString *)path;

@end
