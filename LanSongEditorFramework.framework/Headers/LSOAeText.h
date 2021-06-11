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

@property (nonatomic, readonly) NSString *textlayerName;//图层的名字;

@property (nonatomic, readonly) CGFloat textFontSize;//字号
@property (nonatomic, readonly) NSString *textFont;  //字体字符串;
@property (nonatomic, readonly) NSString *textContents;  //文本内容;
@property (nonatomic, readonly) int  textJustification;   //int;
@property (nonatomic, readonly) int textTracking;  //int;
@property (nonatomic, readonly) CGFloat textLineHeight;  //线高;
/**
 设置文本图层的文字内容
 */
-(void)setTextLayerText:(NSString * _Nullable)text;

/**
 设置文本图层的字体;

 @param fontPath 字体的绝对路径;
 */
-(void)setTextLayerFontPath:(NSString *_Nullable)fontPath;

/**
  设置文本图层的字体;

 @param font 字体对象
 */
-(void)setTextLayerFont:(UIFont *_Nullable)font;


/**
 设置颜色;
 */
-(void)setTextLayerColor:(UIColor *)color;

/**
 设置字号
 */
-(void)setTextLayerFontSize:(CGFloat)fontSize;



//内部使用;
- (instancetype _Nonnull)initWithID:(id)myId;
@end

NS_ASSUME_NONNULL_END
