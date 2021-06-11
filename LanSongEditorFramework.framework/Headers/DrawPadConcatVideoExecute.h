//
//  DrawPadConcatVideoExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/19.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOVideoPen2.h"

NS_ASSUME_NONNULL_BEGIN

/**
 多个视频拼接.
 如果视频的开始时间不是0; 可以先用LanSongEditMode来转换一下;
 */
@interface DrawPadConcatVideoExecute : NSObject
/**
 初始化
 初始化后, 输出文件宽高等于第一个视频的宽高
 @param videoArray 多个URL类型的视频
 @return
 */
-(id)initWithURLArray:(NSMutableArray *)videoArray;

/**
 初始化,指定输出视频的宽高

 @param videoArray 多个URL类型的视频
 @param size 输出视频的宽高
 @return
 */
-(id)initWithURLArray:(NSMutableArray *)videoArray drawPadSize:(CGSize)size;

/**
 容器运行的总时间;
 */
@property (nonatomic,readonly)CGFloat durationS;

/**
 当前容器的尺寸,
 如果你没有设置,则默认是第一个视频的宽高.
 */
@property (nonatomic,assign) CGSize drawpadSize;

/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view;
/**
 增加背景图片
 增加后,会自动放最底层,然后宽高缩放到容器大小.
 内部代码是这样的:
 BitmapPen *bmpPen=xxx拿到图片图层;
 [self setPenPosition:bmpPen index:0];
 bmpPen.scaleWidthValue=_drawpadSize.width;
 bmpPen.scaleHeightValue=_drawpadSize.height;
 返回.
 @param image
 @return
 */
-(LSOBitmapPen *)addBackgroundBitmapPen:(UIImage *)image;
/**
 增加图片图层
 
 @param image 图片
 @return 返回图片图层对象; 或nil;
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;

/**
 增加一个mv图层
 
 @param colorPath mv图层的颜色视频
 @param maskPath mv图层的黑白视频
 @return 返回mv对象或nil;
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/**
 删除图层
 */
-(void)removePen:(LSOPen *)pen;


/**
 交换两个图层在容器中的上下层位置
 [在开始前调用]
 
 @param first 第一个图层
 @param second 第二个图层
 @return 成功返回YES;
 */
-(BOOL)exchangePenPosition:(LSOPen *)first second:(LSOPen *)second;

/**
 设置图层在容器中的位置;
 [在开始前调用]
 
 @param pen 图层对象
 @param index 位置, 最底层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

/**
 获取当前图层的数量
 */
-(int)getPenCount;

/**
 设置录制的码率
 在startRecord前调用;
 */
-(void)setRecordBitrate:(int)bitrate;

/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;

/**
 进度回调,
 progress是当前时间戳, percent是0--1的百分比;
 
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess,CGFloat percent);


/**
 编码完成回调, 完成后返回生成的视频路径;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;
@end
/********************************************************
 例子代码(demo):
 DrawPadConcatVideoExecute *execute;
 -(void)testConcatVideos
 {
     NSMutableArray *videoArray=[[NSMutableArray alloc] init];
     NSURL *inputVideo1 = [[NSBundle mainBundle] URLForResource:@"aobama" withExtension:@"mp4"];
     [videoArray addObject:inputVideo1];
 
     NSURL *inputVideo2 = [[NSBundle mainBundle] URLForResource:@"xiaoYa_mvColor" withExtension:@"mp4"];
     [videoArray addObject:inputVideo2];
 
     NSURL *inputVideo3 = [[NSBundle mainBundle] URLForResource:@"a960x540_90" withExtension:@"MP4"];
     [videoArray addObject:inputVideo3];
 
 
     execute=[[DrawPadConcatVideoExecute alloc] initWithURLArray:videoArray drawPadSize:CGSizeMake(540, 960)];
 
     //    execute=[[DrawPadConcatVideoExecute alloc] initWithURLArray:videoArray];  //ok
 
     WS(weakSelf);
     [execute setProgressBlock:^(CGFloat progess,CGFloat percent) {
     LSOLog(@"progress  is :%f, percent:%f",progess,percent)
     }];
 
     //增加一个背景图片
     BitmapPen *pen=[execute addBitmapPen:[UIImage imageNamed:@"t14.jpg"]];
     [execute setPenPosition:pen index:0]; //放到最低层.
 
     [execute setCompletionBlock:^(NSString *dstPath) {
     dispatch_async(dispatch_get_main_queue(), ^{
     [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
     });
     }];
     [execute start];
 }
 */
NS_ASSUME_NONNULL_END
