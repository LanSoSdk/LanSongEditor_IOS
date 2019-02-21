//
//  LSOVideoOneDo.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "MediaInfo.h"
#import "LanSongFilter.h"

NS_ASSUME_NONNULL_BEGIN


/**
 视频的常见处理:
 执行流程是: 先裁剪--->执行各种滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
@interface LSOVideoOneDo : NSObject

-(id)initWithNSURL:(NSURL *)videoURL;

@property (readonly,nonatomic)MediaInfo *mediaInfo;

@property (readonly,nonatomic)BOOL  isRunning;
/**
 得到视频的宽高
 */
-(float)getVideoWidth;

/**
 得到视频的宽高
 */
-(float)getVideoHeight;


/**
 裁剪开始时长
 */
@property(readwrite, nonatomic) float cutStartTimeS;
/**
 要裁剪的时长;
 */
@property(readwrite, nonatomic) float cutDurationTimeS;

/**
 视频裁剪;
 注意:
 1.CGRect中的x,y如是小数,则调整为整数;
 2.CGRect中的width,height如是奇数,则调整为偶数.(能被2整除的数)
 */
@property (readwrite,nonatomic)CGRect cropRect;

/**
 视频缩放;
 */
@property (readwrite,nonatomic)CGSize scaleSize;

/**
 视频编码码率;
 (起到视频压缩的作用)
 */
@property (readwrite,nonatomic)int bitrate;

/**
 视频增加UI图层;
 (可以设置logo, 文字, 等其他控件, 不支持用OpenGL实现的控件,比如AVPlayerLayer)
 
 请务必:
 如果裁剪则view的宽高等于裁剪的宽高;
 如果没有,则等于视频的宽高;
 
 UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, encoderSize.width, encoderSize.height)];
 执行流程是: 先裁剪--->执行各种滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
-(void)setUIView:(UIView *)view;

/**
设置滤镜
(在开始之前调用)
 */
-(void)setFilter:(LanSongFilter *)filter;


/**
 增加马赛克区域.
 
 马赛克的参考宽高是:
 如果裁剪了,则以裁剪的宽高; 没有裁剪,则视频的宽高; 视频的左上角XY是:0.0,0.0
 
 (可增加多个)
 */
-(void)addMosaicRect:(CGRect)rect;



/**
 开始执行
  执行流程是: 先裁剪--->执行各种滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
-(void)start;

/**
 停止执行.停止后,不会调用completionBlock回调;
 */
-(void)stop;
/**
 *     执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^videoProgressBlock)(CGFloat progess,CGFloat percent);
/**
 结束回调.
 执行后返回结果.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *video);
@end

NS_ASSUME_NONNULL_END

/*
 举例如下:
 
 LSOVideoOneDo *videoOneDo;
 -(void)testVideoOneDo:(NSURL *)video
 {
     videoOneDo=[[LSOVideoOneDo alloc] initWithNSURL:video];
 
     //时长剪切
     videoOneDo.cutStartTimeS=3;
     videoOneDo.cutDurationTimeS=10;
 
     //画面裁剪
     [videoOneDo setCropRect:CGRectMake(0.0, 0.0, 540, 540)];
 
     //增加马赛克
     [videoOneDo addMosaicRect:CGRectMake(0.0, 0.0, 270, 270)];
 
     //增加一个View来叠加logo,文字等.
     [videoOneDo setUIView:[self createUIView]];
 
     [videoOneDo setCompletionBlock:^(NSString * _Nonnull video) {
         dispatch_async(dispatch_get_main_queue(), ^{
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:video];
        });
     }];
     [videoOneDo setVideoProgressBlock:^(CGFloat progess) {
        LSLog(@"进度是:%f, 百分比:%f",progess,progess/videoOneDo.mediaInfo.vDuration);
     }];
     [videoOneDo start];
 }
 -(UIView *)createUIView
 {
     UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540,540)];
     rootView.backgroundColor = [UIColor clearColor];
     UIImage *image = [UIImage imageNamed:@"small"];
     UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
     imageView.center = CGPointMake(rootView.bounds.size.width/2, rootView.bounds.size.height/2);
 
     UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 120)];
     label.text=@"杭州蓝松科技";
     label.textColor=[UIColor redColor];
     [rootView addSubview:label];
     [rootView addSubview:imageView];
    return rootView;
 }
 
 */
