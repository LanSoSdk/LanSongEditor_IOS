//
//  LanSongEditorFramework
//
//  Created by sno on 2020/6/18.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface LSOAnimation : LSOObject


/**
 动画的时长;
 可设置,也可以获取;
 */
@property (atomic, assign) CGFloat animationDurationS;

/**
 动画从合成容器的什么位置开始增加;
 
 时间点是:相对于容器而言
 
 不是相对于当前图层;
 */
@property (atomic, assign) CGFloat animationStartTimeFromCompS;





@property (nonatomic, assign) CGFloat layerStartFromCompS;  

@property (nonatomic, strong) NSString *jsonName; 
@property (nonatomic, assign) int animType;




@end

NS_ASSUME_NONNULL_END
