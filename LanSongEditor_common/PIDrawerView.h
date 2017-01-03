//
//  PIDrawerView.h
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};

/**
  来自github上的开源代码, 不属于lansongEditor的一部分, 这里仅仅是作为演示涂鸦使用.
 */
@interface PIDrawerView : UIView

/**
 绘制模式
 */
@property (nonatomic, readwrite) DrawingMode drawingMode;


/**
 颜色选择.
 */
@property (nonatomic, strong) UIColor *selectedColor;

- (void)initialize;
@end
