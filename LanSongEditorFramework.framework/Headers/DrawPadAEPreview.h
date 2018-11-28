//
//  DrawPadAEPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/27.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView2.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LSOAeView.h"

/**
 Ae模板的前台预览容器
 把Ae模板的各种素材, 按照顺序一层一层增加到容器中, 然后开始播放;
 */
@interface DrawPadAEPreview : NSObject


/**
 用initWithURL/initWithPath 增加的背景视频后, 得到的视频图层对象;
 */
@property (nonatomic)   VideoPen *videoPen;


/**
 当前容器大小, 创建后,如果用 initWithURL/initWithPath 则等于视频本身的分辨率
 如果用init创建的,则等于第一个增加的json文件或MV的分辨率;
 */
@property (nonatomic,assign) CGSize drawpadSize;


/**
 初始化
 @param videoPath输入的视频路径
 */
-(id)initWithURL:(NSURL *)videoPath;

/**
 初始化
 @param videoPath 输入的视频路径
 @return
 */
-(id)initWithPath:(NSString *)videoPath;


/**
 不增加背景视频的初始化方法;
 容器大小,生成视频的帧率,时长等于第一个增加的AEJson 图层或 MV图层的分辨率;
 */
-(id)init;

/**
 定位到第几帧
 [当前不可用]
 @param frame 帧数;
 */
-(void)seekToFrame:(int)frame;

/**
 播放速度.
 [当前不可用]
 从0.1 到10;
 0.1是放慢10倍; 10则是加快10倍; 1.0是正常;
 */
-(void)setSpeed:(float)speed;
/**
 停止.
 [当前不可用]
 */
-(void)stop;
/**
 暂停播放
 [当前不可用]
 */
-(void)pause;
/**
 恢复播放
 [当前不可用]
 */
-(void)resume;


/**
 增加预览的显示创建;
 @param view
 */
-(void)addLanSongView:(LanSongView2 *)view;

/**
 增加UI图层;
 
 @param view UI图层
 @param from  这个UI是否来自界面, 如果你已经self.view addSubView增加了这个view,则这里设置为YES;
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;


/**
 增加图片图层

 @param image 图片对象
 @return 返回图片图层对象
 */
-(BitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加mv图层;
 
 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return MV对象
 */
-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/**
 增加Ae图层
 
 在start前增加
 */
-(LSOAeView *)addAEJsonPath:(NSString *)jsonPath;


/**
 交换两个图层的位置
 在开始前调用;
 @param first 第一个图层对象
 @param second 第二个图层对象
 */
-(BOOL)exchangePenPosition:(Pen *)first second:(Pen *)second;

/**
 设置图层的位置
 [在开始前调用]
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(Pen *)pen index:(int)index;

/**
 当前容器的总时长;
 */
@property CGFloat duration;


-(void)removePen:(Pen *)pen;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;


/**
 开始执行,并实时录制;
 @return
 */
-(BOOL)startWithEncode;

/**
 取消
 */
-(void)cancel;

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progress);



/**
 文字使用.
 */
@property(nonatomic, copy) void(^frameProgressBlock)(int frames);

/**
 编码完成回调, 完成后返回生成的视频路径;
 注意:生成的dstPath目标文件, 我们不会删除.如果你多次调用,就会生成多个视频文件;
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
 当前是否在录制
 */
@property (nonatomic,readonly) BOOL isRecording;


@property (nonatomic,readonly) int penCount;

@end
