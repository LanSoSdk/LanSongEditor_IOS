//
//  LanSongMaskBlendFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/10.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVKit/AVKit.h>
#import "LanSongFilter.h"

@interface LanSongMaskBlendFilter : LanSongFilter


/// 初始化
/// @param image 图片,不能是nil
- (id)initWithMaskImage:(UIImage *)image;

/// 切换图片, 遮罩图片
/// @param image 切换不同的有透明的图片, 不能为nil;
-(void)swichMaskUIImage:(UIImage *)image;

@end
