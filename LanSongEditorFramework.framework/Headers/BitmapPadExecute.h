//
//  BitmapPadExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/11/23.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongFilter.h"
#import "LanSongPicture.h"
#import "LanSongFilterPipeline.h"

@interface BitmapPadExecute : NSObject
/**
 用一张图片,一个滤镜; 转换成一张滤镜后的图片.
 如果filter为nil,则返回他本身.
 */
+(UIImage *)getOneImage:(UIImage *)image filter:(LanSongFilter *)filter;
/**
 用一张图片,多个滤镜,得到一张滤镜后的图片.
 原理是:
 图片--->滤镜1--->滤镜2--->....->滤镜后的图片返回.
 如果filter为nil,则返回他本身.
 */
+(UIImage *)getOneImage:(UIImage *)image filterArray:(NSArray *)filters;

/**
 从一张图片 多个滤镜, 分别每个滤镜得到一张图片.
 原理是:
 一个图片--->滤镜1-->滤镜后的图片1
 一个图片--->滤镜2-->滤镜后的图片2
 一个图片--->滤镜3-->滤镜后的图片3
 一个图片--->滤镜4-->滤镜后的图片4
 
 如果其中有一个filter为nil,则增加原image本身.
 */
+(NSMutableArray *)getMoreImageFromOneImage:(UIImage *)image filterArray:(NSMutableArray *)filters;
/*
 ----------------------------------------------------------------------------------------------------------------
 一下为代码演示.
 
 // 图片输入源
 inputImage = [UIImage imageNamed:@"t14.jpg"];
 
 
 CGSize size=self.view.frame.size;
 CGFloat width=size.width/4;
 CGFloat height=size.height/4;
 
 CGFloat startX=0;
 CGFloat startY=60;
 
 
 //单个滤镜
 LanSongSwirlFilter *filter=[[LanSongSwirlFilter alloc] init];
 
 //多个滤镜
 NSMutableArray *array=[[NSMutableArray alloc] init];
 [array addObject:[[IF1977Filter alloc]init]];
 [array addObject:[[IFHefeFilter alloc]init]];
 [array addObject:[[IFXproIIFilter alloc]init]];
 
 
 //单张图片
 UIImageView *view1=[[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
 view1.image=[BitmapPadExecute getOneImage:inputImage filter:filter];
 [self.view  addSubview:view1];
 
 
 //多张图片
 startY+=height+5;
 UIImageView *view2=[[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
 view2.image=[BitmapPadExecute getOneImage:inputImage filterArray:array];
 [self.view addSubview:view2];
 
 //多张图片
 startY+=height+5;
 NSMutableArray *retArray=[BitmapPadExecute getMoreImageFromOneImage:inputImage filterArray:array];
 
 for (UIImage *imgItem in retArray) {
 UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(startX,startY, width, height)];
 startX+=width+5;
 view.image=imgItem;
 [self.view  addSubview:view];
 }
 NSLog(@"获取得到的 array个数是:%lu",(unsigned long)retArray.count);
 */
@end
