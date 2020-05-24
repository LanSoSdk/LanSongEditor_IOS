//
//  DrawPadVideoExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/7.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOVideoPen2.h"
#import "LSOObject.h"


@interface DrawPadVideoExecute : LSOObject


@property (nonatomic,readonly)CGFloat width;
@property (nonatomic,readonly)CGFloat height;


/**
 容器运行的总时间;
 */
@property (nonatomic,readonly)CGFloat duration;

/**
 当前容器的尺寸, 如果你没有设置,则默认是视频的宽高.
 */
@property (nonatomic,readonly) CGSize drawpadSize;

/**
 初始化

 @param videoPath 输入的视频文件
 @return 返回构造对象
 */
-(id)initWithURL:(NSURL *)videoPath;
-(id)initWithPath:(NSString *)videoPath;

-(id)initWithURL:(NSURL *)videoPath drawPadSize:(CGSize)size;
-(id)initWithPath:(NSString *)videoPath drawPadSize:(CGSize)size;

/**
 在initWithXXX后得到的视频图层对象;
 */
@property (nonatomic)   LSOVideoPen2 *videoPen;
/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view;


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
 设置录制视频的宽高;
 设置后, 容器宽高不变, 会在编码的时候, 把容器的所有图层缩放到这个宽高上;
 如果录制视频的宽高比 不等于容器的宽高比,则录制后的图层会变形;
 
 在startRecord前调用;
 @param size 录制视频的宽高
 */
-(void)setRecordSize:(CGSize)size;

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
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);

/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;
/**
 以下是举例;
 DrawPadVideoExecute *testExecute;
 -(void) testVideoExecute
 {
     NSString *defaultVideo=@"dy_xialu2";
     NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
     testExecute=[[DrawPadVideoExecute alloc] initWithURL:sampleURL];
     LanSongIFHefeFilter *filter=[[LanSongIFHefeFilter alloc] init];
     [testExecute.videoPen switchFilter:filter];
     
     
     LSOSubPen *pen1=[testExecute.videoPen addSubPen];
     pen1.scaleHeight=0.5;
     pen1.scaleWidth=0.5;
     pen1.positionX=pen1.scaleWidthValue/2;
     pen1.positionY=pen1.scaleHeightValue/2;
     
     LSOSubPen *pen2=[testExecute.videoPen addSubPen];
     pen2.scaleHeight=0.5;
     pen2.scaleWidth=0.5;
     pen2.positionX=pen1.scaleWidthValue +pen2.scaleWidthValue/2;
     pen2.positionY=pen2.scaleHeightValue/2;
     
     LSOSubPen *pen3=[testExecute.videoPen addSubPen];
     pen3.scaleHeight=0.5;
     pen3.scaleWidth=0.5;
     pen3.positionX=pen3.scaleWidthValue/2;
     pen3.positionY=pen1.scaleHeightValue + pen3.scaleHeightValue/2;
     
     
     LSOSubPen *pen4=[testExecute.videoPen addSubPen];
     pen4.scaleHeight=0.5;
     pen4.scaleWidth=0.5;
     pen4.positionX=pen3.scaleWidthValue +pen4.scaleWidthValue/2;
     pen4.positionY=pen2.scaleHeightValue +pen4.scaleHeightValue/2;
     
     
     //增加Bitmap
     UIImage *image=[UIImage imageNamed:@"mm"];
     LSOBitmapPen *bmpPen1=[testExecute addBitmapPen:image];
     [bmpPen1 setDisplayTimeRange:0.0 endTimeS:1.0];
     
     image=[UIImage imageNamed:@"small"];
     bmpPen1=[testExecute addBitmapPen:image];
     [bmpPen1 setDisplayTimeRange:1.0 endTimeS:3.0];
     
     image=[UIImage imageNamed:@"pic1"];
    bmpPen1=[testExecute addBitmapPen:image];
    [bmpPen1 setDisplayTimeRange:3.0 endTimeS:5.0];
     
     image=[UIImage imageNamed:@"pic2"];
    bmpPen1=[testExecute addBitmapPen:image];
    [bmpPen1 setDisplayTimeRange:5.0 endTimeS:8.0];
     
     
     image=[UIImage imageNamed:@"pic3"];
    bmpPen1=[testExecute addBitmapPen:image];
    [bmpPen1 setDisplayTimeRange:8.0 endTimeS:10.0];
     
     //增加MV图层
     NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
     NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
     [testExecute addMVPen:colorPath withMask:maskPath];
     
     __weak typeof(self) weakSelf = self;
     [testExecute setProgressBlock:^(CGFloat progess) {
         LSOLog(@"即将处理时间(进度)是:%f,百分比是:%f",progess,progess/testExecute.duration);
     }];
     
     [testExecute setCompletionBlock:^(NSString *dstPath) {
         LSOLog(@"处理完毕");
         dispatch_async(dispatch_get_main_queue(), ^{
             [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
         });
     }];
     [testExecute start];
 }
 */
@end
