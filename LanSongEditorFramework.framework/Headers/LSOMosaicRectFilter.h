//
//  LanSongMosaicRectFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/7.
//  Copyright © 2019 sno. All rights reserved.
//
#import "LanSongFilter.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOMosaicRectFilter  : LanSongFilter


/**
 马赛克中的每个马赛克像素块的大小; 默认0.08
  范围是0---0.5f;
 */
@property(readwrite, nonatomic) CGFloat fractionalWidthOfAPixel;


/**
 马赛克的区域.
 rect的 xy,宽高, 分别对应的是:
 
 x,y: 对应左上角开始的位置, 即从图像哪个位置开始做马赛克; 范围是0.0--1.0f;
 
 宽高: 表示以xy为开始点, 做多宽和多高的马赛克区域; 范围是0.0--1.0f;
 */
@property(readwrite, nonatomic) CGRect mosaicRect;

@end
NS_ASSUME_NONNULL_END

