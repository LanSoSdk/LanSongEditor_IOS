//
//  LSOEffect.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/6/20.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"


NS_ASSUME_NONNULL_BEGIN


@interface LSOEffect : LSOObject


/**
 特效的时长;
 可设置,也可以获取;
 */
@property (nonatomic, assign) CGFloat effectDurationS;

/**
 特效从合成容器的什么位置开始增加;
 
 时间点是:相对于容器而言
 
 不是相对于当前图层;
 */
@property (nonatomic, assign) CGFloat effectStartTimeFromCompS;






@end

NS_ASSUME_NONNULL_END
