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
#import "LSOObject.h"

/**
 图片后台容器.
 当前仅是滤镜.
 
 BitmapPadPreview,你可以直接在预览的时候, 生成图片, 无需后台.
 */
@interface BitmapPadExecute : LSOObject


+(UIImage *)getOneImage:(UIImage *)image filter:(LanSongOutput <LanSongInput> *)filter  LSO_DELPRECATED;
+(UIImage *)getOneImage:(UIImage *)image filterArray:(NSArray *)filters LSO_DELPRECATED;
+(NSMutableArray *)getMoreImageFromOneImage:(UIImage *)image filterArray:(NSMutableArray *)filters LSO_DELPRECATED;


/**
 用一张图片,一个滤镜; 转换成一张滤镜后的图片.
 如果filter为nil,则返回他本身.
 如果有一个滤镜失败, 则增加原图片. 您可以用 [得到的图片 isEqual:原来的图片 ]来判断当前图片是否有效.(常用图片几乎都有效)
 如果你要用缩略图,建议缩放到640x480左右;
 */
+(UIImage *)getOneImage:(UIImage *)image filter:(LanSongOutput <LanSongInput> *)filter scaleSize:(CGSize)scaleSize;


/**
 用一张图片,多个滤镜,得到一张滤镜后的图片.
 原理是:
 图片--->滤镜1--->滤镜2--->....->滤镜后的图片返回.
 如果filter为nil,则返回他本身.
 如果有一个滤镜失败, 则增加原图片. 您可以用 [得到的图片 isEqual:原来的图片 ]来判断当前图片是否有效.(常用图片几乎都有效)
  如果你要用缩略图,建议缩放到640x480左右;
 */
+(UIImage *)getOneImage:(UIImage *)image filterArray:(NSArray *)filters scaleSize:(CGSize)scaleSize;


/**
 从一张图片 多个滤镜, 分别每个滤镜得到一张图片.
 原理是:
 一个图片--->滤镜1-->滤镜后的图片1
 --->滤镜2-->滤镜后的图片2
 --->滤镜3-->滤镜后的图片3
 --->滤镜4-->滤镜后的图片4
 
 如果其中有一个filter为nil,则增加原image本身.
 如果有一个滤镜失败, 则增加原图片. 您可以用 [得到的图片 isEqual:原来的图片 ]来判断当前图片是否有效.(常用图片几乎都有效)
   如果你要用缩略图,建议缩放到640x480左右;
 */

+(NSMutableArray *)getMoreImageFromOneImage:(UIImage *)image filterArray:(NSMutableArray *)filters scaleSize:(CGSize)scaleSize;

/*
 ----------------------------------------------------------------------------------------------------------------
 一下为代码演示.
 
 LanSongSwirlFilter *filter=[[LanSongSwirlFilter alloc] init];
   UIImage *inputImage=[UIImage imageNamed:@"small"];
   UIImage *image2=[BitmapPadExecute getOneImage:inputImage filter:filter];
   LSOLog(@"------save uiiamge2 is %@",[LSOFileUtil saveUIImage:image2])
 
 
 
 
 // 图片输入源
 UIImage *inputImage = [UIImage imageNamed:@"t14.jpg"];
 
 
 CGSize size=self.view.frame.size;
 CGFloat width=size.width/4;
 CGFloat height=size.height/4;
 
 CGFloat startX=0;
 CGFloat startY=60;
 
 
 //单个滤镜
 LanSongSwirlFilter *filter=[[LanSongSwirlFilter alloc] init];
 
 //多个滤镜
 NSMutableArray *array=[[NSMutableArray alloc] init];
 [array addObject:[[LanSongIF1977Filter alloc]init]];
 [array addObject:[[LanSongIFHefeFilter alloc]init]];
 [array addObject:[[LanSongIFXproIIFilter alloc]init]];
 
 
 //----->单张图片
 UIImageView *view1=[[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
 view1.image=[BitmapPadExecute getOneImage:inputImage filter:filter];
 [self.view  addSubview:view1];
 
 
 //----->多张图片
 startY+=height+5;
 UIImageView *view2=[[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
 view2.image=[BitmapPadExecute getOneImage:inputImage filterArray:array];
 [self.view addSubview:view2];
 
 //----->多张图片
 startY+=height+5;
 NSMutableArray *retArray=[BitmapPadExecute getMoreImageFromOneImage:inputImage filterArray:array];
 
 for (UIImage *imgItem in retArray) {
 UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(startX,startY, width, height)];
 startX+=width+5;
 view.image=imgItem;
 [self.view  addSubview:view];
 }
 LSOLog(@"获取得到的 array个数是:%lu",(unsigned long)retArray.count);
 */
@end
