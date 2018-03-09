//
//  UIView+Curled.m
//  lexue-teacher
//
//  Created by 白冰 on 13-7-19.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import "UIView+Curled.h"
#import "BlazeiceCurledViewBase.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIView (Curled)
-(void)configureBorder:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset

{ 
    [self.layer setBorderWidth:2];
    [self setContentMode:UIViewContentModeCenter];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self.layer setCornerRadius:6.0f];  //cornerRadius
    [self.layer setShadowRadius:2.0];
    [self.layer setShadowOpacity:0.2];
    
    UIBezierPath* path = [BlazeiceCurledViewBase curlShadowPathWithShadowDepth:shadowDepth
                                                   controlPointXOffset:controlPointXOffset
                                                   controlPointYOffset:controlPointYOffset
                                                               forView:self];
    [self.layer setShadowPath:path.CGPath];
}

-(void)setborderWidth:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowHeight controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset

{
    
    // delegate to CurledViewBase
    [self configureBorder:borderWidth shadowDepth:shadowHeight controlPointXOffset:controlPointXOffset controlPointYOffset:controlPointYOffset];
}
@end
