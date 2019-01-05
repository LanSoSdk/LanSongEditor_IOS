//
//  LSOOneLineText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOOneLineText : NSObject

@property UIImage *imageOriginal;
@property int  index;


//------------当前的时间戳.
@property float startTimeS;

//如果不是当前行
@property float endTimeS;


//------json中的 image信息
//图层的开始帧数
@property (nonatomic, assign) int startFrame;
//图层的结束帧数, UI制作的时候, 有可能很大, 这个不要使用.
@property (nonatomic, assign) int endFrame;
@property NSString  *jsonImageID;
@property int  jsonImageWidth;
@property int  jsonImageHeight;
@property UIImage  *jsonImage;


///-----文字信息..
//字号,默认35;
@property int fontSize;
//LSTODO暂定.
@property NSMutableParagraphStyle *style;
//文字
@property (nonatomic,copy) NSString *text;
//文字颜色
@property (nonatomic,copy) UIColor *textColor;
//根据文字创建好的图片.
@property (nonatomic,copy) UIImage *textImage;

@end

NS_ASSUME_NONNULL_END
