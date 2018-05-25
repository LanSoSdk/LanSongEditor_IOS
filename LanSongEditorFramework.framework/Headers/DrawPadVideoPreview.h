//
//  DrawPadVideoPreview.h
//
//  Created by sno on 2018/5/24.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView.h"

@interface DrawPadVideoPreview : NSObject


/**
 创建对象

 @param size 容器的大小, 也是生成视频的大小
 @param view 容器预览要显示到的窗口
 @return
 */
-(id)initWithSize:(CGSize)size view:(LanSongView *)view;

/**
 增加视频图层
 
 @param path 视频路径
 @return 返回视频图层对象
 */
-(VideoPen *)addVideoPen:(NSString *)path;

/**
 增加视频图层, [URL格式]

 当前只能增加唯一一个视频图层.
 
 @param path 视频路径
 @return 返回对象
 */
-(VideoPen *)addVideoPenWithURL:(NSURL *)path;


/**
 增加UI图层; 举例有增加Lottie

 @param view UI图层
 @param from 这个UI来自界面; 当前请设置为YES
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;


/**
 开始执行

 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;


/**
 进度回调, 也是当前视频图层的视频播放进度 时间单位是秒;;
 是工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);


/**
 完成回调, 完成后返回生成的视频路径;
 是工作在其他线程,
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
