//
//  EditFileBox.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/11/16.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LanSongEditorFramework/LanSongEditor.h>


/**
 此文件当前封装的有:
 文件路径;
 MediaInfo;
 
 
 (后续会增加别的,比如操作用到的滤镜等等)
 */
@interface EditFileBox : NSObject


/**
 内部会执行MediaInfo的prepare, 如果prepare执行失败, 返回null.
 @param path 文件路径
 @return 返回当前对象或nil
 */
-(id)initWithPath:(NSString *)path;

-(id)initWithMediaInfo:(MediaInfo *)info;


/**
 文件路径.
 */
@property NSString *srcVideoPath;

/**
  初始化时的文件信息.
 */
@property MediaInfo *info;

/**
 当前处理这个视频的容器宽度
 */
@property CGFloat  drawpadWidth;


/**
 当前处理这个视频的容器高度.
 */
@property CGFloat  drawpadHeight;

/**
  处理的过程中, 当前视频图层要旋转的角度.
 */
@property CGFloat  videoAngle;




@end
