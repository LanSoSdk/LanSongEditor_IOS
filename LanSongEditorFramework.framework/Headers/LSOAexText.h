//
//  LSOAexText.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOAexOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAexText : LSOObject



/// 在pc端的原始文字.
@property (nonatomic,readonly) NSString *originalText;

///文字字号
@property (nonatomic, readonly) CGFloat originalTextFontSize;//double

///文字在PC设计时字体;(当前暂时不能修改, 默认字体为系统字体)
@property (nonatomic, readonly) NSString *originalTextFont;



/**
 这个图片的开始时间点
 */
@property (nonatomic, readonly) CGFloat startTimeS;

/**
 当前图片的显示时长;
 */
@property (nonatomic, readonly) CGFloat durationS;

//----------------------用户设置的--------------------------------------------

/// 更改文字
/// @param text 要替换的文字
-(void)updateText:(NSString *)text;

/**
 用 updateText设置的文字.
这里是只读;
 */
@property (nonatomic,readonly) NSString *userText;


/**
 如果你要对文字做其他操作, 则我们建议用这个设置;
 
 */
-(void)updateTextWithImage:(UIImage *)image;


/**
 你可以在更新文字之前, 设置一个字体颜色;
 */
@property (nonatomic, readwrite) UIColor *userColor;

/**
 只是让你附带一帧缩略图对象, 内部没有代码, 也不使用;
 如果你要附带更多的参数,请用lsoTag对象;
 */
@property (nonatomic, readwrite) UIImage *thumbnailImage;




@property (readwrite,assign) BOOL  needUpdate;

@end
NS_ASSUME_NONNULL_END
