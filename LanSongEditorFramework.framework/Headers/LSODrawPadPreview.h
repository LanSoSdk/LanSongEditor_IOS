
//
//  DrawPadVideoPreview.h
//
//  Created by sno on 2018/5/24.
//  Copyright © 2018年 sno. All rights reserved.

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"


NS_ASSUME_NONNULL_BEGIN
@interface LSODrawPadPreview : NSObject


/**
 当前容器的总长度,等于视频的长度;
 单位秒;
 */
@property (nonatomic,readonly)   CGFloat duration;

@property (nonatomic,readonly)   CGFloat width;
@property (nonatomic,readonly)   CGFloat height;


/**
初始化
 根据宽度,高度, 总长度, 刷新帧率
 */
-(id)initWithSize:(CGSize)drawPadSize durationS:(CGFloat)duration frameRate:(CGFloat)frameRate;


/**
 初始化,指定输出视频的宽高
 
 [视频拼接用]
 @param videoArray 多个URL类型的视频
 @param size 输出视频的宽高
 @return
 */
-(id)initWithURLArray:(NSMutableArray *)videoArray drawPadSize:(CGSize)size;
/**
 初始化
 [视频拼接用]
 初始化后, 输出文件宽高等于第一个视频的宽高
 @param videoArray 多个URL类型的视频
 @return
 */
-(id)initWithURLArray:(NSMutableArray *)videoArray;


@property (nonatomic,assign) CGSize drawpadSize;



-(LSOVideoPen *)addVideoPen:(NSURL *)videoURL;

/**
 设置预览窗口.
 */
-(void)setLanSongView:(LanSongView2 *)view;

/**
 
 使用:
 //为了保持UI图层不变形,
 //应该先创建一个和LanSongView2一样大小的viewA增加到self.view上,再把要增加的view增加到这个viewA中;
 UIView *view=[[UIView alloc] initWithFrame:lansongView.frame];
 [self.view addSubview:view];
 [view addSubview:yourView];//<----把你的 UI增加到view中;
 [drawpadPreview addViewPen:view isFromUI:YES];
 
 @param view UI图层
 @param from  这个UI是否来自界面, 如果你已经self.view addSubView增加了这个view,则这里设置为YES;
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;

-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

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
 容器开始预览;
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;
/**
 容器停止预览
 */
-(void)stop;


-(BOOL)isPaused;
/**
 容器暂停
 */
-(void)pause;
/**
 容器暂停后的恢复播放;
 */
-(void)resume;
/**
 开始录制
 录制的每一帧时间戳, 通过recordProgressBlock返回;
 @return
 */
/**
 取消
 */
-(void)cancel;

/**
 预览进度; 也是当前视频的播放进度;
 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^previewProgressBlock)(CGFloat progress,CGFloat percent);


/**
 每次编码完毕, 都会调用这里;
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

@end
NS_ASSUME_NONNULL_END
