//
//  UIView+ZXQuartz.h
//  quartz
//
//  Created by 张 玺 on 12-12-24.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZXQuartz)

void replace(CGFloat quartzWidth, CGFloat quartzAlpha ,UIColor *quartzColor);
//矩形
-(void)drawRectangle:(CGRect)rect;
//圆角矩形
-(void)drawRectangle:(CGRect)rect withRadius:(float)radius;
//画多边形
//pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
-(void)drawPolygon:(NSArray *)pointArray;
//圆形
-(void)drawCircleWithCenter:(CGPoint)center
                     radius:(float)radius;
//曲线
-(void)drawCurveFrom:(CGPoint)startPoint
                  to:(CGPoint)endPoint
       controlPoint1:(CGPoint)controlPoint1
       controlPoint2:(CGPoint)controlPoint2;

//弧线
-(void)drawArcFromCenter:(CGPoint)center
                  radius:(float)radius
              startAngle:(float)startAngle
                endAngle:(float)endAngle
               clockwise:(BOOL)clockwise;
//扇形
-(void)drawSectorFromCenter:(CGPoint)center
                     radius:(float)radius
                 startAngle:(float)startAngle
                   endAngle:(float)endAngle
                  clockwise:(BOOL)clockwise;

//直线
-(void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint ;

/*
折线，连续直线
pointArray = @[[NSValue valueWithCGPoint:CGPointMake(200, 400)]];
 */
-(void)drawLines:(NSArray *)pointArray;

-(void)drawText:(CGRect)rect;

-(CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius;

/*
  边框线
 */

- (void) drawEditboxLines:(CGRect)rect;

/*
  绘制图像
 */
- (void) imageDrawWith:(CGAffineTransform)transform toImage:(UIImage *)image;

//test
- (void) drawTreeBarWithRect:(CGRect)rect Vals:(NSArray *)options refs:(NSArray *)refs num:(int)count stdCount:(NSInteger)stdCount;
@end
