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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BlazeiceCommon.h"
#import "BlazeiceDEBUG.h"

#define ACEDrawingViewVersion   1.0.0

typedef enum {
    ACEDrawingToolTypePen,
    ACEDrawingToolTypeMedia,
    ACEDrawingToolTypeLine,
    ACEDrawingToolTypeRectagleStroke,
    ACEDrawingToolTypeRectagleFill,
    ACEDrawingToolTypeEllipseStroke,
    ACEDrawingToolTypeEllipseFill,
} ACEDrawingToolType;

@protocol Mark;
@class RDPObject;
@interface ACEDrawingView : UIView<UITextViewDelegate>
{
    BOOL TextOrPen;//记录当前是批注/图层
    BOOL assist;//远程控制
    CGPoint lastPoint;
    CGPoint lastPoint2;
    
    CGPoint boxBeganPoint;
    RDPObject *rdpMake;
    RDPObject *newRdpMake;
    BOOL isToClear;
    BOOL isToCancel;
}
@property (nonatomic, strong) RDPObject *rdpMake;
@property (nonatomic, strong)  NSMutableArray *array;
@property (nonatomic, assign)  NSString *text;
@property (nonatomic, assign)  BOOL dashOrline;//虚线、实线
@property (nonatomic, assign)  BOOL formPush;
@property (nonatomic, strong) id<Mark>currentTool;
@property (nonatomic, strong) id<Mark>rdpmakeTool;
@property (nonatomic, assign)  ACEDrawingToolType drawTool;
@property (nonatomic, assign)  BOOL TextOrPen;
@property (nonatomic, assign)  BOOL assist;
@property (nonatomic, assign)  BOOL isSssistDraw;
@property (nonatomic, assign)  BOOL isTouch;
@property (nonatomic, strong) NSString *commentMeg;
// public properties
@property (nonatomic, assign) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) BOOL isclear;

@property (nonatomic, strong) NSMutableArray *beforPushArray;
@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITextView *infoView;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isbox;

+ (id)sharedManager;
-(void)addNote;
-(void)stopAddNote;
// erase all
- (void)clear;
- (void)undoLatestStep;
- (void)rodoLatestStep;
- (void)cancelLastPath;
- (void)exitCanvasViewEditor;

- (ACEDrawingView *)showCommentView:(NSString *)comment;
- (ACEDrawingView *)showImageView:(UIImage *)image;

- (void)setrdpData:(RDPObject *)newData;
- (void)updateCacheImage:(BOOL)redraw;
@end

