//
//  LanSongBeautyFilter.h
//  LanSongEditorFramework
//
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongFilter.h"

@interface LanSongBeautyFilter : LanSongFilter



/**
 设置当前美颜级别;默认是0.6
 范围是0.0---1.0;
 

 @param level 
 */
-(void) setBeautyLevel:(CGFloat) level;
/**
设置当前美颜级别;默认是0.6
范围是0.0---1.0;


@param level
*/
@property (readwrite, assign)CGFloat beautyLevel;

@end
