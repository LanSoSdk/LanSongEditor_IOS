//
//  BeautyManager.h
//  LanSongEditorFramework
//
//  Created by sno on 09/03/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongUtils.h"

@interface BeautyManager : NSObject

@property BOOL isBeauting;  //是否已经增加滤镜

@property LanSongBeautyTuneFilter *beautyFilter;


@property LanSongLookupFilter  *lookupFilter;



//-----------方法

/**
 增加美颜

 @param cameraPen 当前获取到摄像头图层对象
 */
-(void)addBeauty:(CameraPen *)cameraPen;

/**
 删除美颜

 @param cameraPen 摄像头图层对象
 */
-(void)deleteBeauty:(CameraPen *)cameraPen;


/**
 当增加美颜后, 调节冷暖色;
 0.0为暖色; 
 1.0 为冷色;
默认是0.22;
 @param level 级别;
 */
-(void)setWarmCoolEffect:(CGFloat)level;

@end
