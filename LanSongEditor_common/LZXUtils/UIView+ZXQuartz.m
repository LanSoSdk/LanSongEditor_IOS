//
//  UIView+ZXQuartz.m
//  quartz
//
//  Created by 张 玺 on 12-12-24.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#define PI 3.1415926

#import "UIView+ZXQuartz.h"
#import "UIColor+Extend.h"

@implementation UIView (ZXQuartz)
static CGFloat width;
static CGFloat alpha;
static UIColor *color;
void replace(CGFloat quartzWidth, CGFloat quartzAlpha ,UIColor *quartzColor)
{
    width = quartzWidth;
    alpha = quartzAlpha;
    color = quartzColor;
}
//矩形
-(void)drawRectangle:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties

       CGContextSetAlpha(context, alpha);
    // draw the rectangle
    
    CGRect rectToFill = CGRectMake(rect.origin.x, rect.origin.y, 60, 60);
     CGContextSetStrokeColorWithColor(context, color.CGColor);
   CGContextSetLineWidth(context, width);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);

}
//圆角矩形
-(void)drawRectangle:(CGRect)rect withRadius:(float)radius
{
    CGContextRef   context = UIGraphicsGetCurrentContext();
    CGMutablePathRef pathRef = [self pathwithFrame:rect withRadius:radius];
    CGContextAddPath(context, pathRef);
    CGContextDrawPath(context,kCGPathFillStroke);
    CGPathRelease(pathRef);
}
//多边形
-(void)drawPolygon:(NSArray *)pointArray
{
    NSAssert(pointArray.count>=2,@"数组长度必须大于等于2");
    NSAssert([[pointArray[0] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
    
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    NSValue *startPointValue = pointArray[0];
    CGPoint  startPoint      = [startPointValue CGPointValue];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    
    for(int i = 1;i<pointArray.count;i++)
    {
        NSAssert([[pointArray[i] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
        NSValue *pointValue = pointArray[i];
        CGPoint  point      = [pointValue CGPointValue];
        CGContextAddLineToPoint(context, point.x,point.y);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}
//圆形
-(void)drawCircleWithCenter:(CGPoint)center radius:(float)radius
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, alpha);
    // draw the ellipse
    CGRect rectToFill = CGRectMake(center.x, center.y, 60, 60);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);

}
//曲线
-(void)drawCurveFrom:(CGPoint)startPoint to:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw the ellipse
    CGContextSetAlpha(context, alpha);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddCurveToPoint(context,
                             controlPoint1.x,
                             controlPoint1.y,
                             controlPoint2.x,
                             controlPoint2.y,
                             endPoint.x,
                             endPoint.y);
    
    CGContextDrawPath(context,kCGPathStroke);
  



}
//弧线
-(void)drawArcFromCenter:(CGPoint)center
                  radius:(float)radius
              startAngle:(float)startAngle
                endAngle:(float)endAngle
               clockwise:(BOOL)clockwise
{
    CGContextRef     context = UIGraphicsGetCurrentContext();

    CGContextAddArc(context,
                    center.x,
                    center.y,
                    radius,
                    startAngle,
                    endAngle,
                    clockwise?0:1);
    
    CGContextStrokePath(context);
}
//扇形
-(void)drawSectorFromCenter:(CGPoint)center
                     radius:(float)radius
                 startAngle:(float)startAngle
                   endAngle:(float)endAngle
                  clockwise:(BOOL)clockwise
{
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    
    CGContextMoveToPoint(context, center.x, center.y);
    
    CGContextAddArc(context,
                    center.x,
                    center.y,
                    radius,
                    startAngle,
                    endAngle,
                    clockwise?0:1);
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);
}
- (void)drawText:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
     CGContextSetAlpha(context, alpha);
    UIFont *fout =  [UIFont fontWithName:@"HelveticaNeue" size:width];
    NSString *text = [NSString stringWithFormat:@"Text"];
    [text drawInRect:CGRectMake(100,30,100,50) withFont:fout];
    CGContextStrokePath(context);
    CGContextFillPath(context);
}

//直线
-(void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    CGContextRef    context = UIGraphicsGetCurrentContext();
    // set the line properties
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context,  width);
    CGContextSetAlpha(context, alpha);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x,endPoint.y);
    CGContextStrokePath(context);

}
-(void)drawLines:(NSArray *)pointArray
{
    NSAssert(pointArray.count>=2,@"数组长度必须大于等于2");
    NSAssert([[pointArray[0] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
    
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    NSValue *startPointValue = pointArray[0];
    CGPoint  startPoint      = [startPointValue CGPointValue];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    
    for(int i = 1;i<pointArray.count;i++)
    {
         NSAssert([[pointArray[i] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
         NSValue *pointValue = pointArray[i];
         CGPoint  point      = [pointValue CGPointValue];
         CGContextAddLineToPoint(context, point.x,point.y);
    }
    
    CGContextStrokePath(context);
}

-(CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius
{
    CGPoint x1,x2,x3,x4; //x为4个顶点
    CGPoint y1,y2,y3,y4,y5,y6,y7,y8; //y为4个控制点
    //从左上角顶点开始，顺时针旋转,x1->y1->y2->x2
    
    x1 = frame.origin;
    x2 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
    x3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
    x4 = CGPointMake(frame.origin.x                 , frame.origin.y+frame.size.height);
    
    
    y1 = CGPointMake(frame.origin.x+radius, frame.origin.y);
    y2 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y);
    y3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+radius);
    y4 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height-radius);
    
    y5 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+frame.size.height);
    y6 = CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height);
    y7 = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height-radius);
    y8 = CGPointMake(frame.origin.x, frame.origin.y+radius);
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    if (radius<=0) {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, x1.x,x1.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x,x2.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x,x3.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x,x4.y);
    }else
    {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, y1.x,y1.y);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y2.x,y2.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x2.x,x2.y,y3.x,y3.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y4.x,y4.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x3.x,x3.y,y5.x,y5.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y6.x,y6.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x4.x,x4.y,y7.x,y7.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y8.x,y8.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x1.x,x1.y,y1.x,y1.y,radius);
        
    }
    
    
    CGPathCloseSubpath(pathRef);
    
    //[[UIColor whiteColor] setFill];
    //[[UIColor blackColor] setStroke];
    
    return pathRef;
}

#define kSPUserResizableViewGlobalInset 5.0

#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

- (void) drawEditboxLines:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // (1) Draw the bounding box.
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    // (2) Calculate the bounding boxes for each of the anchor points.
    CGRect upperLeft = CGRectMake(0.0, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect upperRight = CGRectMake(self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect lowerRight = CGRectMake(self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize, self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect lowerLeft = CGRectMake(0.0, self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect upperMiddle = CGRectMake((self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize)/2, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect lowerMiddle = CGRectMake((self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize)/2, self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect middleLeft = CGRectMake(0.0, (self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize)/2, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect middleRight = CGRectMake(self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize, (self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize)/2, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    
    // (3) Create the gradient to paint the anchor points.
    CGFloat colors [] = {
        //        0.4, 0.8, 1.0, 1.0,
        0.2, 0.9, 0.5, 1.0,
        //        0.0, 0.0, 1.0, 1.0
        0.5, 0.8, 1.0, 1.0
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // (4) Set up the stroke for drawing the border of each of the anchor points.
    CGContextSetLineWidth(context, 1);
    CGContextSetShadow(context, CGSizeMake(0.5, 0.5), 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // (5) Fill each anchor point using the gradient, then stroke the border.
    CGRect allPoints[8] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight };
    for (NSInteger i = 0; i < 8; i++) {
        CGRect currPoint = allPoints[i];
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, currPoint);
        CGContextClip(context);
        CGPoint startPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMinY(currPoint));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMaxY(currPoint));
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
        CGContextStrokeEllipseInRect(context, CGRectInset(currPoint, 1, 1));
    }
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);

}
- (void) imageDrawWith:(CGAffineTransform)transform toImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform myTr = transform;
    CGContextConcatCTM(context, myTr);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context,CGRectMake(0,0,image.size.width,image.size.height),[image CGImage]);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //_ps(image.size);
    [newImg drawInRect:CGRectMake(0,0,newImg.size.width,newImg.size.height)];
}
//
-(NSString*)changValueAndText:(NSString*)str
{
    NSString* aStr=[NSString stringWithFormat:@"%@",str];
    if ([str isEqualToString:@"0"]) {
        aStr=@"A";
    }
    else if([str isEqualToString:@"1"]){
        aStr=@"B";
    }
    else if([str isEqualToString:@"2"]){
        aStr=@"C";
    }
    else if([str isEqualToString:@"3"]){
        aStr=@"D";
    }
    else if([str isEqualToString:@"4"]){
        aStr=@"E";
    }
    else if([str isEqualToString:@"5"]){
        aStr=@"F";
    }
    else if([str isEqualToString:@"6"]){
        aStr=@"G";
    }
    else if ([str isEqualToString:@"7"]){
        aStr=@"H";
    }
    else if ([str isEqualToString:@"8"]){
        aStr=@"I";
    }
    else if ([str isEqualToString:@"9"]){
        aStr=@"J";
    }
    else if ([str isEqualToString:@"10"]){
        aStr=@"K";
    }
    return aStr;
}

-(NSString*)changTextAndValue:(NSString*)str
{
    NSString* aStr=[NSString stringWithFormat:@"%@",str];
    if ([str isEqualToString:@"A"]) {
        aStr=@"0";
    }
    else if([str isEqualToString:@"B"]){
        aStr=@"1";
    }
    else if([str isEqualToString:@"C"]){
        aStr=@"2";
    }
    else if([str isEqualToString:@"D"]){
        aStr=@"3";
    }
    else if([str isEqualToString:@"E"]){
        aStr=@"4";
    }
    else if([str isEqualToString:@"F"]){
        aStr=@"5";
    }
    else if([str isEqualToString:@"G"]){
        aStr=@"6";
    }
    else if ([str isEqualToString:@"7"]){
        aStr=@"H";
    }
    else if ([str isEqualToString:@"8"]){
        aStr=@"I";
    }
    else if ([str isEqualToString:@"9"]){
        aStr=@"J";
    }
    else if ([str isEqualToString:@"10"]){
        aStr=@"K";
    }
    return aStr;
}

//绘制树状图
- (void) drawTreeBarWithRect:(CGRect)rect Vals:(NSArray *)options refs:(NSArray *)refs num:(int)count stdCount:(NSInteger)stdCount
{
    __block float maxLen;
    __block  float rectWidth = 30;
    __block float LBL_HEIGHT = 20.0f,T_HEIGHT = 25.0f, iLen, x, heightRatio, height, y;
    __block UIColor *iColor;
    NSLog(@"--%@--%@----%d",options,refs,count);
    /// Draw Bars
    CGContextRef context = UIGraphicsGetCurrentContext();
    __block  float maxHight = 0.0;
    [options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        iLen = [[obj valueForKey:@"value"] floatValue];
        if (iLen > maxHight) {
            maxHight = iLen;
        }
    }];
    [options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        iLen = [[obj valueForKey:@"value"] floatValue];
        maxLen = 100;
        x = idx * (rectWidth) + 10;
        heightRatio = iLen / maxLen;
        CGFloat maxH = rect.size.height - T_HEIGHT - LBL_HEIGHT;
        height = heightRatio * maxH;//实际的最高
        y = rect.size.height  - LBL_HEIGHT  - height ;
        CGRect aframe = CGRectMake(20.0f + (rect.size.width/count ) * (idx % count) - (idx % count),y, rectWidth , height );
        /// Reference Label.
        UILabel *lblRef = [[UILabel alloc] initWithFrame:CGRectMake(aframe.origin.x + 10, rect.size.height - LBL_HEIGHT, aframe.size.width, LBL_HEIGHT)];
        lblRef.text = [self changValueAndText:[[options objectAtIndex:idx] valueForKey:@"text"]];
        if (self.tag==5) {
            if ([lblRef.text isEqualToString:@"A"]) {
                lblRef.text=@"错误";
            }
            else if([lblRef.text isEqualToString:@"B"]){
                lblRef.text=@"正确";
            }
            lblRef.frame=CGRectMake(aframe.origin.x -2, rect.size.height - LBL_HEIGHT, aframe.size.width, LBL_HEIGHT);
        }
        lblRef.textColor = [UIColor blackColor];
        [lblRef setTextAlignment:NSTextAlignmentCenter];
        lblRef.backgroundColor = [UIColor clearColor];
        [lblRef sizeToFit];
        [self addSubview:lblRef];
        //title
        [[UIColor blueColor] set];
        UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
        float ratio = 0.0f;
        if ([options count]>idx) {
            ratio=[[[options objectAtIndex:idx] valueForKey:@"value"] floatValue];
        }
        
        NSString *str = @"%";
        NSString *ratioStr = [[NSString stringWithFormat:@"%.0f人/%.1f",ratio*stdCount/100,ratio] stringByAppendingFormat:@"%@",str];
        [ratioStr drawAtPoint:CGPointMake(aframe.origin.x, aframe.origin.y - 25 )
                     withFont:helveticaBold];
        
         /// Set color and draw the bar
        id rightbaby = @"0";
        if (options) {
            if ([options count]>idx) {
                rightbaby=[self changTextAndValue:[[options objectAtIndex:idx] valueForKey:@"text"]];
            }
        }
        
        if([refs containsObject:rightbaby])
            iColor = [UIColor colorWithHexString:@"529f13"];
        else
            iColor = [UIColor lightGrayColor];
        CGContextSetFillColorWithColor(context, iColor.CGColor);
        CGContextFillRect(context, aframe);
    }];

    /// pivot
    CGRect frameX = CGRectZero;
    frameX.origin.x = rect.origin.x;
    frameX.origin.y = rect.origin.y - LBL_HEIGHT;
    frameX.size.height = LBL_HEIGHT;
    frameX.size.width = rect.size.width;
    UILabel *pivotLabel = [[UILabel alloc] initWithFrame:frameX];
    
    pivotLabel.text = @"统计";
    pivotLabel.backgroundColor = [UIColor clearColor];
    pivotLabel.textColor = [UIColor yellowColor];
    [self addSubview:pivotLabel];
    
    /// A line
    frameX = rect;
    frameX.size.height = 1.0;
    frameX.origin.y = rect.size.height - LBL_HEIGHT;
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, frameX);
    
    CGRect frameY = CGRectZero;
    frameY = CGRectMake(0, 0, 1, rect.size.height - 20);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, frameY);
}
@end
