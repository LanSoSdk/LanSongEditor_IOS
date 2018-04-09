//
//  LanSongColorEdgeFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 05/04/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

#import "LanSongFilter.h"
/**
 把画面的颜色错位,并反色显示出来;
 错位的颜色向左侧偏移, setVolume值越大,则偏移的越厉害;
 */
@interface LanSongColorEdgeFilter : LanSongFilter

/**
 等于1.0的时候, 是原画面;
 值越小,则颜色块越偏离原来的位置; 颜色块越大;
 建议最小是0.5; 默认是0.8
 @param value 值;
 */
- (void)setVolume:(CGFloat)value;


//增加白色抠图;


@end
