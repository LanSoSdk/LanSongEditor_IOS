//
//  LSOAEVideoSetting.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/3/17.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAEVideoSetting : LSOObject

/**
 视频的开始时间
 [不设置等于0]
 */
@property(nonatomic, assign) CGFloat startTimeS;

/**
 视频的结束时间.
 [不设置则等于-1;]
 */
@property(nonatomic, assign) CGFloat endTimeS;
/**
 * 是否循环
 默认为YES
 */
@property(nonatomic, assign) BOOL isLooping;
/**
 * 是否调整帧率,和json中的帧率一致
 默认为YES
 */
@property(nonatomic, assign) BOOL isFrameRateSameAsJson;

/**
 * 是否调整大小, 和json中的一致
 默认为YES
 */
@property(nonatomic, assign) BOOL isSizeSameAsJson;

//-------------新增加一下代码---------------------------

/**
 视频裁剪尺寸;
 如果设置此功能, 则isSizeSameAsJson会等于NO,无效;
 */
@property(readwrite, nonatomic) CGRect videoFrameCropRect;



/**
 对视频帧做:2D变换;
 
 如果你做设置videoFrameCropRect:  则以videoFrameCropRect的宽高为处理的宽高.
 如果没有设置:
 1.isSizeSameAsJson=YES: 则是当前json中图片id的宽高.
 2. isSizeSameAsJson=NO:   则是视频帧的宽高;
 
 我们内部是一个GPU渲染线程. CGAffineTransform转换为CATransform3D, 然后直接设置当前帧的状态.
 
 */
@property(readwrite, nonatomic) CGAffineTransform videoFrameAffineTransform;

/**
 对视频帧做:3D变换,
 如果你做设置videoFrameCropRect:  则以videoFrameCropRect的宽高为处理的宽高.
 如果没有设置:
   1.isSizeSameAsJson=YES: 则是当前json中图片id的宽高.
   2. isSizeSameAsJson=NO:   则是视频帧的宽高;
 
 我们内部是一个GPU渲染线程. CATransform3D是直接设置当前帧的状态.
 */
@property(readwrite, nonatomic) CATransform3D videoFrameTransform3D;

@end

NS_ASSUME_NONNULL_END
