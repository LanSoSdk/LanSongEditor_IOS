//
//  LSOBitmapAsset.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/23.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"


NS_ASSUME_NONNULL_BEGIN


/// 创建图片资源, 蓝松SDK把各种外部资源封装一个一个的Asset, 方便内部操作;
@interface LSOBitmapAsset : LSOObject


/// 全局方法
/// @param URL 视频路径;
+ (instancetype)assetWithPath:(NSString *)path;
+ (instancetype)assetWithURL:(NSURL *)URL;
+ (instancetype)assetWithImage:(UIImage *)image;

///初始化,
/// @param path 图片路径
-(id)initWithPath:(NSString *)path;


/// 初始化
/// @param url 图片URL路径
-(id)initWithURL:(NSURL *)url;


/// 初始化
/// @param image 图片对象
-(id)initWithUIImage:(UIImage *)image;


@property (nonatomic,readonly) NSURL *uiimageURL;

@property (nonatomic,readonly) NSString *uiimagePath;

@property (nonatomic,readonly) UIImage *uiImage;
@end

NS_ASSUME_NONNULL_END
