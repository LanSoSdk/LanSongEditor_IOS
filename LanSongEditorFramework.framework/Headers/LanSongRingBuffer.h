//
//  LanSongRingBuffer.h
//  tstAAC
//
//  Created by sno on 2017/11/21.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanSongRingBuffer : NSObject


/**
 初始化大小

 @param size 参考大小, 实际以内存页来做最终的大小, 比如内存是16k一页的, 则您设置小于16k的大小, 也会用16k作为默认大小.
 */
-(id)initWithSize:(int)size;


/**
 已经使用了多少字节
 */
-(int)getUsedSize;

/**
 没有使用的字节数, 即还可以最大填入多少个字节.
 
 @return <#return value description#>
 */
-(int)getUnusedSize;

/**
 向内部增加数据.

 @param buffer 数据指针
 @param len 数据的长度
 @return 返回实际增加的个数
 */
-(int)addData:(void *)buffer len:(int)len;


/**
 获取数据

 @param buffer 外部创建好的内存地址
 @param len 要获取的长度(最大不能大于 buffer的长度)
 @return 实际返回的长度
 */
-(int)getData:(void *)buffer len:(int)len;

/*
 ----------- ----------- ----------- ----------- ----------- ----------- ----------- -----------
 以下是测试代码:
 
 LanSongRingBuffer *ring=[[LanSongRingBuffer alloc] initWithSize:4096];
 
 int len=1000;
 char *src=(char *)malloc(2000);
 
 memset(src,1,1000);
 
 for(int i=0;i<17;i++){
 int ret= [ring addData:src len:len];
 LSLog(@"增加的个数是:%d, ret=:%d",i,ret);
 }
 
 for(int i=0;i<16;i++){
 int ret= [ring getData:src len:len];
 LSLog(@"获取的个数是:%d, ret=:%d",i,ret);
 }
 
 //以下测试: 先完全填满, 然后读取还剩下300个, 再次填1000个, 一次性读取1300个, 看是否可以.
 //      这样还剩下384个.
 LSLog(@"还剩下的个数是:%d",[ring getUsedSize]);
 
 
 memset(src,2,1000);  //填入2.
 int ret= [ring addData:src len:len];
 LSLog(@"再次填入1000个:%d",ret);
 
 
 int ret2= [ring getData:src len:1384];
 LSLog(@"看下获取到的个数是::%d",ret2);
 //测试打印的数据是正确的, 即先取出384个1, 然后是1000个2;
 for(int i=0;i<ret2;i++){
 LSLog(@"%d",src[i]);
 }
 
 
 */
@end
