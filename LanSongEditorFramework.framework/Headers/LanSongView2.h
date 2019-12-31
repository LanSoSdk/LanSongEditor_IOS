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
#import "LSOPen.h"




typedef NS_ENUM(NSUInteger, LanSongFillModeType2) {
    kLanSongFillModeStretch2,
    kLanSongFillModePreserveAspectRatio2,
    kLanSongFillModePreserveAspectRatioAndFill2
};
@interface LanSongView2 : UIView <LanSongInput>
{
    LanSongRotationMode inputRotation;
}

@property(nonatomic, copy) void(^updatePenBlock)();

@property(readwrite, nonatomic) LanSongFillModeType2 fillMode;
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;



/**
 截图;
 @return 返回当前LanSongView2的数据;
 */
-(UIImage *)snapshot;
/**
 预览进度;
 */
@property(nonatomic, copy) void(^previewProgressBlock)(CGFloat progess);


//----------一下为内部使用, 外界不要使用--------------
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
-(void)setPenArray:(NSMutableArray *)array;
-(void)setPenArray2:(NSMutableArray *)array;
-(void)setDrivePen:(LSOPen *)pen;
-(void)resetDriver;
@property (nonatomic)BOOL forceUpdate;
@end
