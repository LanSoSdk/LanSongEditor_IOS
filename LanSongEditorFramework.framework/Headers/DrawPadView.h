//
//  DrawPadVideo.h
//  SimpleVideoFileFilter
//
//  Created by sno on 16/8/17.
//  Copyright © 2016年 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUImage.h"

@interface DrawPadView : NSObject

/**
 *    DrawPad执行完成后的回调.
 
        注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
        dispatch_async(dispatch_get_main_queue(), ^{
                .....CODEC....
        });
 */
@property(nonatomic, copy) void(^onCompletionBlock)(void);

/**
 *     DrawPad执行过程中的进度对调.
 
        注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
        dispatch_async(dispatch_get_main_queue(), ^{
            .....CODEC....
        });
 */
@property(nonatomic, copy) void(^onProgressBlock)(CGFloat);
/**
 *  drawPad的高度和宽度.注意:这里是像素值, 不是 屏幕点,如果您使用, 要根据layer.contentScale来得到屏幕点.
 */
@property CGFloat width;
@property CGFloat height;

/**
 *   初始化
 *
 *  @param srcPath 输入视频源
 *  @param dstPath 目标视频路径名.
 *
 *  @return <#return value description#>
 */

- (id)initWithPath:(NSString *)srcPath dstPath:(NSString *)dstPath;


/**
 *  设置DrawPad开始工作前的priview和filter
 *
 *  @param preview 处理过程中需要显示的UIView,后台会做根据视频的宽高做等比例缩放
 *  @param filter 处理视频时需要的滤镜效果, 如不需要滤镜,则设置为nil
 */
-(void) setDrawPadPreView:(UIView *)preview filter:(GPUImageFilter *)filter;

/**
 *  增加UI画笔.
 */
-(void)addUIPen:(UIView *)view fromUI:(BOOL)fromUI;

-(CGFloat)getDrawPadWidth;
-(CGFloat)getDrawPadHeight;


/**
 *  切换滤镜, 您可以在setOnProgressBlock的地方检查当前处理的进度, 当处理到您需要的地方,可以切换实时的切换滤镜.
 *
 *  @param filter 滤镜对象,如不需要滤镜, 则设置为nil
 */
-(void)switchFilterTo:(GPUImageFilter *)filter;

/**
 *  开始执行.
 */
-(void)startDrawPad;

/**
 *  DrawPad是否已经在工作了
 *
 *  @return
 */
-(BOOL) isWorking;

@end
