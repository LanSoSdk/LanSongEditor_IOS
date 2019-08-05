//
//  MyDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 17/2/21.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LSOPen.h"
#import "LSOMediaInfo.h"
/**
 当MV播放到最后一帧的时候, 做合作方式处理
 */
typedef NS_ENUM(NSUInteger, MVEndMode) {
    /*循环播放 ,默认是循环.*/
    kMVMode_Loop,
    /*停留在最后一帧*/
    kMVMode_LastFrame,
    /*消失*/
    kMVMode_Hide
};


/**
 * Source object for filtering movies
 * 解码传递过来的文件路径. 解码
 */
@interface LSOMVPen : LSOPen

/**
 MV当播放到最后一帧时, 采用何种方式.
  有, 循环播放/停留在最后一帧/消失三种方法.
 默认是循环
 */
@property (nonatomic) MVEndMode mvMode;
@property(nonatomic,readonly) LSOMediaInfo *mediaInfo;


/**
 设置使用MV的原始尺寸显示.
 默认是放到到当前容器的尺寸;
 */
-(void)setUseOriginalSize:(BOOL)is;


/**
 特定客户使用;
 */
@property(nonatomic, copy) void(^mvPenAssetReaderError)();

/*********一下是内部使用*******************/
- (id)initWithURL:(NSURL *)url maks:(NSURL *) url2 drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;
-(void)setPlayerId:(id)player;
@property(readwrite, nonatomic) BOOL playAtActualSpeed;

@end
