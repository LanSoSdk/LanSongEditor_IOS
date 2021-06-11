//
//  BitmapPadPreview.h
//
//  Created by sno on 2018/10/14.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"


/**
 
 图片容器, 您可以把很多图片一层一层的调进来, 然后截取得到一张叠加后的图片.
 
 整理自 DrawPadVideoPreview;
 
 如果DrawPadVideoPreview已经满足你们的使用场景;只需要得到画面,则
 则直接调用lansongView.snapshot即可截取当前容器的画面,不必再次使用这个;
 */
@interface BitmapPadPreview : NSObject
/**
 用视频路径初始化; 初始化后得到videoPen对象;
 */
-(id)initWithVideo:(NSString *)videoPath;


/**
 用图片初始化;
 */
-(id)initWithUIImage:(UIImage *)image;



/**
 用容器尺寸初始化;
 */
-(id)initWithSize:(CGSize)size;

/**
 initWithVideo时得到的videoPen对象
 */
@property (nonatomic,readonly)   LSOVideoPen *videoPen;


/**
 initWithUIImage 得到的BitmapPen对象;
 */
@property (nonatomic,readonly)   LSOBitmapPen *bitmapPen;

@property (nonatomic,assign) CGSize drawpadSize;




-(void)addLanSongView:(LanSongView2 *)view;

-(LSOViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;

-(void)removePen:(LSOPen *)pen;


/**
 容器开始预览;
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;
/**
 容器停止预览
 */
-(void)stop;


/**
 获取当前容器的画面;
 等于 [LanSongView2 snapshot];
 */
-(UIImage *)snapshotImage;
@end

