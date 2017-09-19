//
//  DrawPadView.h
//  LanSongEditorFramework
//
//  Created by sno on 17/1/7.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanSongContext.h"
#import "LanSongView.h"


@interface DrawPadView : UIView
{
    LanSongRotationMode inputRotation;
}

/** The fill mode dictates how images are fit in the view, with the default being kLanSongFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) LanSongFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;


/**
 内部使用

 @param newValue <#newValue description#>
 */
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

+ (const GLfloat *)textureCoordinatesForRotation:(LanSongRotationMode)rotationMode;


/**
 内部使用
 */
-(void)makeCurrent;


/**
 内部使用
 */
-(void)pushToDisplay;

@end
