//
//  LSOVideoLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/21.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LSOLayer.h"
#import "LSOVideoAsset.h"
#import "LSOAeAnimation.h"
#import "LSOVideoOption.h"


NS_ASSUME_NONNULL_BEGIN


/**
 视频/图片 拼接层;
 */
@interface LSOVideoLayer : LSOLayer



/**
 异步 获取缩略图;
 当前是每秒钟获取一帧;, 一帧宽高最大是100x100;
 image 是获取到的每一张缩略图;
 finish是 是否获取完毕;
 */
- (void)getThumbnailAsyncWithHandler:(void (^)(UIImage *image, BOOL finish))handler;

/**
 在你第一次调用过getThumbnailAsyncWithHandler后. 内部会保存到这个属性中.
 在下次获取的时候, 则可以直接读取;
 */
@property(nonatomic, readwrite)  NSMutableArray<UIImage *> *thumbImageArray;




@end

NS_ASSUME_NONNULL_END
