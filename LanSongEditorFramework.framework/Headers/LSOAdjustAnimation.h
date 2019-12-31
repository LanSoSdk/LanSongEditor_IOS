//
//  LSOAdjustAnimation.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/11/28.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LanSongFilter.h"
#import "LSOAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAdjustAnimation : LSOAnimation




///动画的滤镜在处理过程中的回调, 你需要在此方法里增加对滤镜的操作
@property(nonatomic, copy) void(^animationProgressBlock)(LanSongFilter *filter, CGFloat percent);

@end

NS_ASSUME_NONNULL_END
