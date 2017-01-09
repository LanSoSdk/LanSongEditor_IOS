//
//  DrawPadView.h
//  LanSongEditorFramework
//
//  Created by sno on 17/1/7.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImageContext.h"
#import "GPUImageView.h"


@interface DrawPadView : UIView
{
    GPUImageRotationMode inputRotation;
}

/** The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) GPUImageFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;


- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

+ (const GLfloat *)textureCoordinatesForRotation:(GPUImageRotationMode)rotationMode;

-(void)makeCurrent;

-(void)pushToDisplay;

@end
