/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "BlazeicePlist.h"

#define  kScribbleDataPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data"]
#define SEAVERTAG  0
#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f
#define kDefaultLineAlpha       1.0f
#define kTextViewTag            60
#define kTooBarTag              80

// experimental code
#define PARTIAL_REDRAW          0

@interface ACEDrawingView ()<UIGestureRecognizerDelegate>
@end

//NSString * const SegChandeNotification = @"ChangeTheSelectedNotification";
#pragma mark -
@implementation ACEDrawingView
@synthesize text;
@synthesize dashOrline;
@synthesize array;
@synthesize infoView;
@synthesize drawTool;
@synthesize TextOrPen;
@synthesize currentTool;
@synthesize isRecording;
@synthesize rdpmakeTool;
@synthesize rdpMake;
@synthesize assist;
@synthesize isSssistDraw;
@synthesize commentMeg;
@synthesize isTouch;
@synthesize formPush;

GZOBJECT_SINGLETON_BOILERPLATE(ACEDrawingView, sharedManager)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    self.pathArray = [NSMutableArray array];
    self.beforPushArray = [NSMutableArray array];
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    ///
}
- (void)setrdpData:(RDPObject *)newData
{
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    if (self.isclear) {
        [self.currentTool setIsClear:_isclear];
    }
    if(!isToCancel)
    {
        [self.currentTool draw];
    }
    if (isToClear) {
        isToClear=NO;
        isToCancel=NO;
        if (!self.currentTool) {
            self.currentTool= [self toolWithCurrentSettings];
        }
    }
#endif
    // [NSThread detachNewThreadSelector:@selector(updateairimage) toTarget:self withObject:nil];
}
- (void)exitCanvasViewEditor
{
    self.currentTool = [self toolWithCurrentSettings];
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.drawTool = ACEDrawingToolTypeMedia;
        self.currentTool = [self toolWithCurrentSettings];
        [self.pathArray addObject:self.currentTool];
    }];
    [self exitEditMode];
    [self setNeedsDisplay];
}
- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<Mark> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // useded for airPlayWindow
//    BlazeiceAirplayWindow *airwPlayWindow = [BlazeiceAirplayWindow sharedInstance];
//    if(airwPlayWindow.contectionSwitch == YES){
//        [airwPlayWindow.ariPlayImageView setImage:self.image];
//        [airwPlayWindow.ariPlayImageView setNeedsDisplay];
//    }
}

-(void)updateCacheImageWith:(id<Mark>)newMark
{
     UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // set the draw point
    [self.image drawAtPoint:CGPointZero];
    [newMark draw];
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (id<Mark>)toolWithCurrentSettings
{
    switch (self.drawTool) {
        case ACEDrawingToolTypePen:
        {
            ACEDrawingPenTool *tool=ACE_AUTORELEASE([ACEDrawingPenTool new]);
            return tool;
        }
        case ACEDrawingToolTypeMedia:
        {
            ACEDrawingMediaTool *tool=ACE_AUTORELEASE([ACEDrawingMediaTool new]);
            [tool receiveObject:^(id object) {
                self.array = object;
                self.array = nil;
            }];
            tool.mediaArray = self.array;
            return tool;
        }
        case ACEDrawingToolTypeLine:
        {
            
            ACEDrawingLineTool *tool = ACE_AUTORELEASE([ACEDrawingLineTool new]);
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
    }
}

- (id<Mark>)toolWithCurrentSettingsWithDrawTool:(ACEDrawingToolType)newdraw
{
    switch (newdraw) {
        case ACEDrawingToolTypePen:
        {
            ACEDrawingPenTool *tool=ACE_AUTORELEASE([ACEDrawingPenTool new]);
            return tool;
        }
        case ACEDrawingToolTypeMedia:
        {
            ACEDrawingMediaTool *tool=ACE_AUTORELEASE([ACEDrawingMediaTool new]);
            [tool receiveObject:^(id object) {
                self.array = object;
                self.array = nil;
            }];
            tool.mediaArray = self.array;
            return tool;
        }
        case ACEDrawingToolTypeLine:
        {
            
            ACEDrawingLineTool *tool = ACE_AUTORELEASE([ACEDrawingLineTool new]);
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
    }
}

- (ACEDrawingView *)showCommentView:(NSString *)comment
{
    //添加手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SinglePan:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    //文本
    infoView=[[UITextView alloc]initWithFrame:CGRectMake(30, 50, 400, 100)];
    infoView.backgroundColor=[UIColor clearColor];
    //不自动纠错
    [infoView setAutocorrectionType:UITextAutocorrectionTypeNo];
    infoView.delegate=self;
    //增加边框
    [infoView.layer setMasksToBounds:YES];
    [infoView.layer setCornerRadius:4.0];
    [infoView.layer setBorderWidth:2.0];
    [infoView.layer setBorderColor:[UIColor colorWithRed:166 green:166 blue:166 alpha:0.8].CGColor];
    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    //字体
    infoView.font=[UIFont fontWithName:@"Arial" size:self.lineWidth];
    infoView.textColor=self.lineColor;
    infoView.text = comment;
    [infoView addGestureRecognizer:panGestureRecognizer];
    [self addNote];
    if([infoView.text length]== 0){
        infoView.text = @"请输入批注内容：";
    }
    else{
        float height=[infoView sizeThatFits:CGSizeMake(CGRectGetWidth(infoView.frame), FLT_MAX)].height;
        if (height<580) {
            if (height<100) {
                infoView.frame=CGRectMake(30, 50, 400, 100);
            }
            else{
                infoView.frame=CGRectMake(30, 50, 400, height);
            }
        }
        else{
            infoView.frame=CGRectMake(30, 50, 400, 580);
        }
    }
    [infoView setTag:kTextViewTag];
    [self addSubview:infoView];
    infoView.text = comment;
    if([infoView.text length]== 0){
        infoView.text = @"请输入批注内容：";
    }
    self.text=@"";
    
    if(self.array == nil){
        self.array = [NSMutableArray array];
    }
    [self.array addObject:infoView];
    self.drawTool = ACEDrawingToolTypeMedia;
    
    return self;
    
}
- (ACEDrawingView *)showImageView:(UIImage *)image
{
    //添加手势
    CGRect aFrame = CGRectMake(0, 0, image.size.width, image.size.height);
  // SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:aFrame];
//    //tap
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SinglePan:)];
//    [gestureRecognizer setDelegate:self];
//    [userResizableView addGestureRecognizer:gestureRecognizer];
    
    if (self.array==nil) {
        self.array=[NSMutableArray array];
    }
    self.drawTool = ACEDrawingToolTypeMedia;
    //
    [self becomeFirstResponder];
    UIMenuItem *cencelItem = [[UIMenuItem alloc] initWithTitle:@"取消" action:@selector(cencel:)];
    UIMenuItem *doneItem = [[UIMenuItem alloc] initWithTitle:@"确定" action:@selector(done:)];
    [UIMenuController sharedMenuController].menuItems = @[doneItem, cencelItem,];
    
    return self;
    
}

#pragma mark - UIMenu
- (void)cencel:(id)sender
{
//    //恢复类型设置
//    BlazeiceCoordinatingController *coordinatingController = [BlazeiceCoordinatingController sharedInstance];
//    BlazeiceDoodleViewController *canvasViewController = [coordinatingController canvasViewController];
//    [[[canvasViewController canvasBar] buttonArray] enumerateObjectsUsingBlock:^(BlazeiceToolButton * toolsBtn, NSUInteger idx, BOOL *stop) {
//        if([toolsBtn isSelected]){
//            //匹配类型
//            [[canvasViewController canvasBar] verifyTypeWithBtn:toolsBtn];
//            *stop = YES;
//        }
//    }];
}

- (void)done:(id)sender
{
    [self exitCanvasViewEditor];
   // [self restoration];//恢复类型
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cencel:) || action == @selector(done:))
        return YES;
    return [super canPerformAction:action withSender:sender];
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
- (void)  exitEditMode
{
    // init the bezier path
    self.currentTool.lineAlpha = self.lineAlpha;
    // update the image
    [self updateCacheImage:NO];
    // clear the current tool
    self.currentTool = nil;
    // clear the redo queue
  
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
- (ACEDrawingToolType) restoration//恢复类型
{
    return ACEDrawingToolTypeMedia;
}
#pragma mark - Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //*********************随堂作业学生白板 start****************************//
    if ([self.accessibilityHint isEqualToString:@"current student"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toMoveOrAddPanGesture" object:@"0"];
    }
    //*********************随堂作业学生白板 end****************************//
    // add the first touch
    UITouch *touch = [touches anyObject];
   
    boxBeganPoint=[touch locationInView:self];//工具用
    
    if([touch.view isKindOfClass:[self class]])
    {
        // init the bezier path
        if(!formPush){
            self.drawTool = [self restoration];//恢复类型
        }
        CGPoint point=[touch locationInView:self];
        self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineWidth = self.lineWidth;
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineAlpha = self.lineAlpha;
        if (self.isclear) {
            [self.currentTool setIsClear:_isclear];
        }
        
        if(self.drawTool == ACEDrawingToolTypeMedia && self.array == nil)
        {
            [self showCommentView:nil];
            UIView *textView=(UIView *)[self viewWithTag:kTextViewTag];
            textView.frame = CGRectMake(point.x, point.y, 400, 100);
            return;
        }
        [self.pathArray addObject:self.currentTool];
        // add the first touch
        UITouch *touch = [touches anyObject];
        [self.currentTool setInitialPoint:[touch locationInView:self]];

    }
    isTouch = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
    //[self.currentTool setEndPoint:currentLocation];//远程用
    
    if(self.drawTool == ACEDrawingToolTypeMedia){
        [self setNeedsDisplay];
        return;
    }
    if (/*isRecording&&(!self.isbox)*/self.drawTool == ACEDrawingToolTypePen) {
        CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 1.0;
        CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(lastPoint.x-2,lastPoint.y-2, (lastPoint2.x+4 - lastPoint.x), (lastPoint2.y+4-lastPoint.y))];
        lastPoint=CGPointMake(minX, minY);
        lastPoint2=CGPointMake(maxX, maxY);
        [self setNeedsDisplayInRect:CGRectMake(minX , minY, (maxX- minX), (maxY- minY))];
    }else if(/*isRecording&&self.isbox*/(self.drawTool != ACEDrawingToolTypePen)&&(self.drawTool != ACEDrawingToolTypeMedia)){
        CGFloat minX1 = fmin(boxBeganPoint.x, previousLocation.x) - self.lineWidth * 1.0;
        CGFloat minY1 = fmin(boxBeganPoint.y, previousLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX1 = fmax(boxBeganPoint.x, previousLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY1 = fmax(boxBeganPoint.y, previousLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(minX1-2 , minY1-2, (maxX1+4- minX1), (maxY1+4- minY1))];
        
        CGFloat minX = fmin(boxBeganPoint.x, currentLocation.x) - self.lineWidth * 1.0;
        CGFloat minY = fmin(boxBeganPoint.y, currentLocation.y) - self.lineWidth * 1.0;
        CGFloat maxX = fmax(boxBeganPoint.x, currentLocation.x) + self.lineWidth * 1.0;
        CGFloat maxY = fmax(boxBeganPoint.y, currentLocation.y) + self.lineWidth * 1.0;
        [self setNeedsDisplayInRect:CGRectMake(minX-2 , minY-2, (maxX+4- minX), (maxY+4- minY))];
    } else{
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    UITouch *touch = [touches anyObject];
    if([touch.view isKindOfClass:[self class]]){
        // make sure a point is recorded
        [self touchesMoved:touches withEvent:event];
        [self exitEditMode];
        isTouch = NO;
    }
    //*********************随堂作业学生白板 start****************************//
    if ([self.accessibilityHint isEqualToString:@"current student"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toMoveOrAddPanGesture" object:@"1"];
    }
    //*********************随堂作业学生白板 end****************************//
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}
#pragma -textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //开始编辑 自动去掉提示语
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([textView.text isEqualToString:@"请输入批注内容："]) {
            textView.text=@"";
        }
        self.text=textView.text;
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIFont *nowFount = textView.font;
        CGRect rect = textView.frame;
        
        NSString *nowStr = [NSString stringWithFormat:@"%@",textView.text];
        self.text=nowStr;
        
        float height=[nowStr sizeWithFont:nowFount constrainedToSize:CGSizeMake(390, 570)].height+10;
        //float height=[textView sizeThatFits:CGSizeMake(CGRectGetWidth(rect), FLT_MAX)].height;
        if (height<580) {
            if (height<100) {
                rect.size.height=100;
            }
            else{
                rect.size.height=height;
            }
        }
        else{
            rect.size.height=580;
        }
        
        textView.frame=rect;
    });
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setContentOffset:CGPointMake(0, 0)];
    });
}

#pragma mark - Actions
-(void)addNote
{
    TextOrPen=YES;
}
-(void)stopAddNote
{
    TextOrPen=NO;
}
- (void)clear
{
    isToClear=YES;
    self.array = nil;
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    // 将添加的批注也清空
    for (UITextView *textView in self.subviews) {
        [textView removeFromSuperview];
    }
    for (UIImageView *imageView in self.subviews) {
        [imageView removeFromSuperview];
    }
    self.currentTool = nil;
    [self setNeedsDisplay];
}
#pragma mark - Undo / Redo
- (void)undoLatestStep
{
    if([self.pathArray count] != 0)
    {
        id<Mark>tool = [self.pathArray lastObject];
        if ([self.pathArray containsObject:tool])
        {
            [self.pathArray removeObject:tool];
            [self.beforPushArray addObject:tool];
            [self updateCacheImage:YES];
            [self setNeedsDisplay];
        }
    }
}
- (void)rodoLatestStep
{
    if([self.beforPushArray count] != 0)
    {
        id<Mark>tool = [self.beforPushArray lastObject];
        [self.pathArray addObject:tool];
        [self.beforPushArray removeObject:tool];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (void)cancelLastPath
{
    if([self.pathArray count] != 0)
    {
        isToClear=YES;
        isToCancel=YES;
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

#if !ACE_HAS_ARC
- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    [super dealloc];
}
#endif

@end
