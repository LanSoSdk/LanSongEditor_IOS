//
//  LSOVideoOption.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/11/13.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"


NS_ASSUME_NONNULL_BEGIN


/// 视频在增加到容器中的选项:比如裁剪时长, 裁剪画面,是否循环等;
@interface LSOVideoOption : LSOObject


+ (instancetype)optionWithCutTime:(CGFloat)startS endS:(CGFloat)endS;


-(id)init;



/// 时长裁剪的开始时间点
@property (nonatomic, assign) CGFloat cutStartS;


///时长裁剪的结束时间点
@property (nonatomic, assign) CGFloat cutEndS;


/// 是否禁止声音;
@property (nonatomic, assign) BOOL isDisableAudio;

/// 音量大小,默认是1.0; 大于1.0是放大, 小于1.0是减小, 等于0则无声;
@property (nonatomic, assign) CGFloat audioVolume;

///VideoFramePen2使用,
///和上一个图层的交叠时间;单位秒;
///默认是默认是1秒;如果不交叠,则设置为0;
/// 当前暂时不支持小于1
@property (nonatomic, assign) CGFloat overLapTimeS;


//-------------
//(后续增加:裁剪画面等);

@end

NS_ASSUME_NONNULL_END
