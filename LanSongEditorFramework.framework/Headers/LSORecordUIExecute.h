//
//  LSORecordUIExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/14.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>

#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LSOObject.h"


/**
 录制UI;
 测试代码在下面;
 
 */
@interface LSORecordUIExecute : LSOObject


/**
 初始化

 @param view 要录制的view
 @param size 录制后的大小, 如果不等于view大小,则会缩放
 @param rate 录制的帧率
 @param duration 录制的总时长
 @return
 */
-(id)initWithView:(UIView *)view recordSize:(CGSize)size frameRate:(int)rate duration:(CGFloat)duration;
/**
 增加的图片图层,
 [可选]
 在容器开始运行前增加
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;

/**
 增加mv图层;
 [可选]
 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return 增加后,返回mv图层对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

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
@property (nonatomic,readonly) BOOL isRecording;

/*
 测试代码:
 LSORecordUIExecute *uiExecute;
 UILabel *label;
 int labelCnt;
 -(void)testRecordUI
 {
 UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 960)];
 label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 120)];
 label.textColor=[UIColor redColor];
 label.text=@"测试文字abc124";
 label.font = [UIFont systemFontOfSize:40];  //<----设置字号.
 [view addSubview:label];
 
 
 
 uiExecute=[[LSORecordUIExecute alloc] initWithView:view recordSize:CGSizeMake(540, 960) frameRate:15 duration:12.5f];  //临时这样;
 [uiExecute setProgressBlock:^(CGFloat progess) {
 
 label.text=[NSString stringWithFormat:@"测试自:%d",labelCnt];
 labelCnt++;
 
 dispatch_async(dispatch_get_main_queue(), ^{
     CGPoint point=CGPointMake(label.center.x+2, label.center.y);
     label.center=point;
     LSOLog(@"progress is %f",progess);
 });
 
 }];
 [uiExecute setCompletionBlock:^(NSString *dstPath) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [DemoUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
 });
 
 }];
 [uiExecute start];
 }
 */
@end
