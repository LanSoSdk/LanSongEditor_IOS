//
//  LSOAeAnimation.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/12/2.
//  Copyright © 2019 sno. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LSOAnimation.h"
#import "LanSongFilter.h"
#import "LSOAeView.h"


NS_ASSUME_NONNULL_BEGIN


@interface LSOAeAnimation : LSOAnimation


/// 类方法,用来创建MaskAnimation类;
/// @param jsonPath ae导出的json路径;
/// @param durationS 图片序列执行的时长
+ (instancetype)animationWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;


/// 用带有mask特性的Ae模板json文件来做加载;
/// 建议图片不要过大,无论比例如何, 我们内部都会把您的图片缩放到视频一样宽高,然后做透明效果
/// 建议尽量ae-json中的宽高不要高于720P,
/// @param aeView json的完整路径;
/// @param durationS 这个动画执行的总时长, 时长可以大于aeView,也可以小于aeView的时长;
-(id)initWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;

//*************************一下为内部使用,外界请勿使用***************************************
-(int)drawAnimation:(CGFloat)padPtsS;
@property (nonatomic, readonly) LSOAeView *aeView;

@end

NS_ASSUME_NONNULL_END


