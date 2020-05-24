//
//  LSOAudioLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAudioLayer : LSOObject

-(id)initWithURL:(NSURL *)url;


@property (nonatomic, readonly) CGFloat assetDurationS;

/**
 从增加声音什么位置, 开始裁剪;
 [可调节]
 */
@property (nonatomic, readwrite) CGFloat cutStartTimeS;

/**
 从增加声音的什么位置, 结束裁剪;
 [可调节]
 */
@property (nonatomic, readwrite) CGFloat cutEndTimeS;



@property (nonatomic, readwrite) CGFloat layerDurationS;

/**
 从容器的什么时间点开始增加声音;
 [可调节]
 */
@property (nonatomic, readwrite) CGFloat startTimeOfComp;

/**
 是否循环;
 */
@property (nonatomic, readwrite) BOOL looping;

/**
 调节视频中的音频音量.
 范围是0.0---8.0;
 1.0是原始音量; 大于1.0,是放大; 小于1.0是缩小;
 如果是0.0则无声,
 */
@property (nonatomic, assign)CGFloat audioVolume;







@end

NS_ASSUME_NONNULL_END
