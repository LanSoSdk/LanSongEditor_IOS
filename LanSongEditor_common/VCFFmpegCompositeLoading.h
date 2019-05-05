//
//  VCFFmpegCompositeLoading.h
//  VCore
//
//  Created by mac on 2019/1/25.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface VCFFmpegCompositeLoading : UIView
- (void)show;
- (void)configProgress:(CGFloat)progress;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
