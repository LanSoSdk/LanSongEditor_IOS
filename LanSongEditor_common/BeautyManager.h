//
//  BeautyManager.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "BeautyManager.h"

#import <Foundation/Foundation.h>
#import "DemoUtils.h"


@interface BeautyManager : NSObject

@property BOOL isBeauting;  //是否已经增加滤镜

@property LanSongBeautyTuneFilter *beautyFilter;


@property LanSongLookupFilter  *lookupFilter;




/**
 增加美颜
 */
-(void)addBeauty:(LSOPen *)pen;
-(void)addBeautyWithVideoOneDo:(LSOVideoOneDo *)videoOneDo;
/**
 删除美颜
 */
-(void)deleteBeauty:(NSObject *)object;
/**
 当增加美颜后, 调节冷暖色;
 0.0为暖色;
 1.0 为冷色;
 默认是0.22;
 @param level 级别;
 */
-(void)setWarmCoolEffect:(CGFloat)level;

@end
