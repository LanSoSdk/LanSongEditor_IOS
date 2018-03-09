//
//  LanSongBeautyTuneFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 07/03/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongFilter.h"

@interface LanSongBeautyTuneFilter : LanSongFilter


/**
 冷暖色调节.
 如果是0.0,则红润;
 1.0则冷色;
 默认0.25;
 */
-(void) setWarmCoolLevel:(float) level;


/**
 恢复默认值;
 */
-(void) setBeautyDefault;

@end
