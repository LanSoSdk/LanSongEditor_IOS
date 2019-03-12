//
//  LSORecordUIPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/12.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LSOAeView.h"

@interface LSORecordUIPreview : NSObject

-(id)initWithView:(UIView *)view recordSize:(CGSize)size frameRate:(int)rate;

/**
 增加图片图层
 [可选,一般增加一个logo]
 此图层不显示出来;
 
 @param image 图片对象
 @return 返回图片图层对象
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加mv图层;
 [可选,一般增加一个logo]
 此图层不显示出来;
 
 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return MV对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

/**
 删除图层;
 */
-(void)removePen:(LSOPen *)pen;

// 开始录制
-(BOOL)startRecord;

// 取消
-(void)cancel;


/**
 停止
 完成后返回生成的视频路径;

 注意:生成的dstPath目标文件, 我们不会删除.如果你多次调用,就会生成多个视频文件;
 工作在其他线程, 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
-(void)stopWithCompletion:(void(^)(NSString *))completionBlock;

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
 当前是否在录制
 */
@property (nonatomic,readonly) BOOL isRecording;

@end
