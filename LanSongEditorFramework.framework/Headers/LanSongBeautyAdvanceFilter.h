//
//  LanSongBeautyAdvanceFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 07/03/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSong.h"

@class LanSongCombinationFilter;

/**
 *  这个是集成 FilterGroup
 */
@interface LanSongBeautyAdvanceFilter : LanSongFilterGroup{
    
    LanSongBilateralFilter          *bilateralFilter;
    
    LanSongCannyEdgeDetectionFilter *cannyEdgeFilter;  //android上暂时没有
    
    LanSongCombinationFilter        *combinationFilter;
    
    LanSongHSBFilter                *hsbFilter;  //android上暂时没有.
}

/**
 *  A normalization factor for the distance between central color and sample color
 *
 *  @param value default 2.0
 */
- (void)setDistanceNormalizationFactor:(CGFloat)value;

/**
 *  Set brightness and saturation
 *
 *  @param brightness [0.0, 2.0], default 1.05
 *  @param saturation [0.0, 2.0], default 1.05
 */
- (void)setBrightness:(CGFloat)brightness saturation:(CGFloat)saturation;

@end
