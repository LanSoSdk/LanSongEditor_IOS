//
//  LSOAEVideoSetting.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/3/17.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOAEVideoSetting : NSObject

/**
 * 是否循环
 默认为YES
 */
@property(nonatomic, assign) BOOL isLooping;
/**
 * 是否调整帧率,和json中的帧率一致
 默认为YES
 */
@property(nonatomic, assign) BOOL isFrameRateSameAsJson;

/**
 * 是否调整大小, 和json中的一致
 默认为YES
 */
@property(nonatomic, assign) BOOL isSizeSameAsJson;

@end

NS_ASSUME_NONNULL_END
