//
//  LSOMaskAnimation.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/11/19.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOAnimation.h"
#import "LanSongFilter.h"
#import "LSOAeView.h"


NS_ASSUME_NONNULL_BEGIN


/// 遮罩动画类
/// 同一个动画对象不能设置到两个不同的图层中;
@interface LSOMaskAnimation : LSOAnimation



/// 类方法,用来创建MaskAnimation类;
/// @param bitmaps 多个图片序列, 里面有透明动画.用AE或别的软件导出的;
/// @param durationS 图片序列执行的时长
+ (instancetype)animationWithUIImageArray:(NSMutableArray *)bitmaps durationS:(CGFloat)durationS;


/// 类方法,用来创建MaskAnimation类;
/// @param jsonPath ae导出的json路径;
/// @param durationS 图片序列执行的时长
+ (instancetype)animationWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;


/// 初始化遮罩动画 bitmaps数据是UIImage类型的数据, bitmaps可以设置到不同的多个LSOMaskAnimation中;
/// 建议图片不要过大,无论比例如何, 我们内部都会把您的图片缩放到视频一样宽高,然后做透明效果
/// @param bitmaps 多个图片序列, 里面有透明动画.用AE或别的软件导出的;
/// @param durationS 这些图片执行的时长,单位秒; 建议是0.5或1.0f
-(id)initWithUIImageArray:(NSMutableArray *)bitmaps durationS:(CGFloat)durationS;




/// 用带有mask特性的Ae模板json文件来做加载;
/// 建议图片不要过大,无论比例如何, 我们内部都会把您的图片缩放到视频一样宽高,然后做透明效果
/// 建议尽量ae-json中的宽高不要高于720P,
/// @param aeView json的完整路径;
/// @param durationS 这个动画执行的总时长, 时长可以大于aeView,也可以小于aeView的时长;
-(id)initWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;

//*************************一下为内部使用,外界请勿使用***************************************
-(void)drawAnimation:(CGFloat)padPtsS handler:(drawAnimationHandler )drawHandler;
-(LanSongFilter *)getProcessFilter;

@end

NS_ASSUME_NONNULL_END


