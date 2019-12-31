//
//  LSOLayoutParam.h
//
//  Created by sno on 2019/1/30.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSOMediaInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOLayoutParam : NSObject

/**
 初始化
 */
-(id)initWithPath:(NSString *)path;

/**
 初始化
 */
-(id)initWithURL:(NSURL *)url;


/**
 视频路径
 或者图片路径;
 */
@property (nonatomic,readonly) NSString *videoPath;
/**
 当是视频的时候, 可以通过mediaInfo获取到当前视频的各种参数;
 */
@property (nonatomic,readonly)  LSOMediaInfo *mediaInfo;

/**
 * 在布局的时候, 当前视频的左上角0,0布局到输出尺寸的 横向坐标X位置
 */
@property (nonatomic,assign) int x;

/**
 * 在布局的时候, 当前视频的左上角0,0布局到输出尺寸的 横向坐标Y位置
 */
@property (nonatomic,assign) int y;

/**
 * 输入的视频宽度是否要缩放; 如果不缩放则这里等于视频的宽度;
 */
@property (nonatomic,assign) int scaleW;
/**
 * 输入的视频高度是否要缩放; 如果不缩放则这里等于视频的高度;
 */
@property (nonatomic,assign) int scaleH;

@end

NS_ASSUME_NONNULL_END
