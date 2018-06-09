//
//  LanSongView2.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/5/31.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LanSongContext.h"
#import "Pen.h"

typedef NS_ENUM(NSUInteger, LanSongFillModeType2) {
    kLanSongFillModeStretch2,                       // Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
    kLanSongFillModePreserveAspectRatio2,           // Maintains the aspect ratio of the source image, adding bars of the specified background color
    kLanSongFillModePreserveAspectRatioAndFill2     // Maintains the aspect ratio of the source image, zooming in on its center to fill the view
};



/**
 UIView subclass to use as an endpoint for displaying LanSong outputs
 */
@interface LanSongView2 : UIView <LanSongInput>
{
    LanSongRotationMode inputRotation;
}

@property(nonatomic, copy) void(^updatePenBlock)();

/** The fill mode dictates how images are fit in the view, with the default being kLanSongFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) LanSongFillModeType2 fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;


/**
 预览进度;
 */
@property(nonatomic, copy) void(^previewProgressBlock)(CGFloat progess);
/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

//lanso++
-(void)updateDraw:(NSMutableArray *)mPenArray;
-(void)setPenArray:(NSMutableArray *)array;
//lanso++
@property (nonatomic)BOOL forceUpdate;
@end
