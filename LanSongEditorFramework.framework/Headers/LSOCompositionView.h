//
//  LSOCompositionView.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/14.
//  Copyright © 2020 sno. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LanSongContext.h"



@class LSOLayer;


typedef NS_ENUM(NSUInteger, LanSongFillModeType3) {
    kLanSongFillModeStretch3,
    kLanSongFillModePreserveAspectRatio3,
    kLanSongFillModePreserveAspectRatioAndFill3
};
@interface LSOCompositionView : UIView <LanSongInput>
{
    LanSongRotationMode inputRotation;
}

@property(nonatomic, copy) void(^updatePenBlock)();

@property(readwrite, nonatomic) LanSongFillModeType3 fillMode;
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;










@end
