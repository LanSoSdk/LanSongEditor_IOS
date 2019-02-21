//
//  LSOLayoutParam.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/30.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MediaInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOLayoutParam : NSObject

-(id)initWithPath:(NSString *)path;
-(id)initWithURL:(NSURL *)url;



@property (nonatomic,readonly) NSString *videoPath;

@property (nonatomic,readonly)  MediaInfo *mediaInfo;

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
