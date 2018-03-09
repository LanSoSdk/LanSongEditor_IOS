//
//  CanvasView.m
//  lexueCanvas
//
//  Created by 白冰 on 13-5-14.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import "BlazeiceDooleView.h"
#import "ACEDrawingView.h"
#import "UIColor+Extend.h"
#import "AppDelegate.h"

@implementation BlazeiceDooleView

@synthesize saveImageView;
@synthesize drawView;

#pragma mark -
#pragma mark Scribble observer method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
        
        /*NSString* colorStr=[WHITECOLORARR objectAtIndex:0];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultsColor"]) {
            colorStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultsColor"];
        }
        if ([colorStr length]<4) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",colorStr]]];
        }
        else{
            self.backgroundColor = [UIColor colorWithHexString:colorStr];
        }*/
        NSString* colorStr=@"475e45";
       // self.backgroundColor = [UIColor colorWithHexString:colorStr];
        self.backgroundColor = [UIColor clearColor];
        //初始化 悬浮图片view
        saveImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        saveImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:saveImageView];
        //初始化 scribble_涂鸦 模型
        drawView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        drawView.drawTool = ACEDrawingToolTypePen;
        drawView.isclear = NO;
        drawView.lineAlpha = 1.0;
        drawView.lineWidth = 3.0;
        drawView.lineColor = [UIColor redColor];
        [self addSubview:drawView];

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}





//设置最先相应
-(void)setNowFirstResponder
{
    [self becomeFirstResponder];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyImage:)];
    UIMenuItem *cancelItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(cancelBoardImage:)];
    [UIMenuController sharedMenuController].menuItems = @[copyItem,cancelItem,];
}

//删除涂鸦图片
-(void)cancelLastSaveImage
{
    if ([saveImageView.subviews count]) {
        [[saveImageView.subviews lastObject] removeFromSuperview];
    }
}

//显示复制按钮
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyImage:)){
        return YES;
    }
    else if(action == @selector(cancelBoardImage:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}


//删除涂鸦图片
-(void)cancelBoardImage:(id)sender
{
    [self cancelLastSaveImage];
}
#pragma mark - SPUserResizableViewDeleagetEed
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)SinglePan:(UIPanGestureRecognizer*)recognizer
{
    UIView *panView = [recognizer view];
    [self adjustAnchorPointForGestureRecognizer:recognizer];
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:[panView superview]];
        
        [panView setCenter:CGPointMake([panView center].x + translation.x, [panView center].y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:[panView superview]];
    }
}

#pragma mark - UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)dealloc
{
}
@end
