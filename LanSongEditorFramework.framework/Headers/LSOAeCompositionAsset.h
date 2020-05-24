//
//  LSOAeCompositionAsset.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/1/31.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOAeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAeCompositionAsset : LSOObject

@property (nonatomic,readonly) CGFloat durationS;

@property (nonatomic,readonly) CGFloat frameRate;

/**
 AE模板的尺寸
 */
@property (nonatomic,readonly) CGSize aeSize;

/**
 增加第一层: 背景视频
 */
-(BOOL)addFirstLayer:(NSURL *)bgVideoUrl;

/**
 增加第二层 : 导出的Ae json图层;
 */
-(BOOL)addSecondLayer:(LSOAeView *)aeView;
/**
 增加第三层 : 导出的MV图层;
 */
-(BOOL)addThirdLayer:(NSURL *)colorUrl maskURL:(NSURL *)maskUrl;
/****************一下内部调用**********************/


-(void)decodeOneFrame;
-(void)drawOneFrame;


@end

NS_ASSUME_NONNULL_END
