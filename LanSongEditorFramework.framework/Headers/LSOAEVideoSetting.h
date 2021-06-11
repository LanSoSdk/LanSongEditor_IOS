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
 [不设置则等于CGFLOAT_MAX]
 */
@property(nonatomic, assign) CGFloat endTimeS;


/**
 角度值0--360度. 默认为0.0
 顺时针旋转.
 */
@property(readwrite, nonatomic)  CGFloat rotateAngle;

/**
 缩放枚举类型;
 */
@property(readwrite,nonatomic) LSOScaleType scaleType;

/**
 缩放到的实际大小值;
 */
@property(readwrite, nonatomic) CGSize scaleSize;

/**
 设置当前视频的在图片ID宽高区域中的位置;
 如果同时设置了缩放,则以缩放后的宽高为计算.
 */
@property(readwrite, nonatomic) CGPoint positionPoint;


/**
设置当前视频的在图片id宽高区域中的位置.
  如果同时设置了缩放,则以缩放后的宽高为计算.
 枚举类型,
 */
@property(readwrite,nonatomic) LSOPositionType positionType;

@end

NS_ASSUME_NONNULL_END
