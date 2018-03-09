//
//  Mark.h
//  lexueCanvas
//
//  Created by 白冰 on 13-5-16.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Mark <NSObject>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL isClear;//橡皮
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGPoint endPoint;
- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
- (void)draw;

@end
