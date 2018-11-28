//
//  LSOAeText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/6.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOAeText : NSObject

//内部使用;
- (instancetype _Nonnull)initWithID:(NSString *)layerId font:(NSString *)font fontsize:(CGFloat)size text:(NSString *)text
                        justification:(int)justification track:(int)track lineheight:(CGFloat) lineheight;

@property (nonatomic, readonly) NSString *textlayerName;//图层的名字;
@property (nonatomic, readonly) CGFloat textFontSize;//字号
@property (nonatomic, readonly) NSString *textFont;  //字体字符串;
@property (nonatomic, readonly) NSString *textContents;  //文本内容;
@property (nonatomic, readonly) int  textJustification;   //int;
@property (nonatomic, readonly) int textTracking;  //int;
@property (nonatomic, readonly) CGFloat textLineHeight;  //线高;

@end

NS_ASSUME_NONNULL_END
