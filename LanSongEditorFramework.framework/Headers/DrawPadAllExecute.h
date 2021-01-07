//
//  DrawPadAllExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/23.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOGifPen.h"

#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LSOObject.h"
#import "LSOBitmapAsset.h"
#import "LSOVideoFramePen.h"
#import "LSOVideoAsset.h"
#import "LSOAeViewPen.h"
#import "LSOVideoFramePen2.h"
#import "LSOAeCompositionAsset.h"
#import "LSOAECompositionPen.h"
NS_ASSUME_NONNULL_BEGIN

/**
 已经废弃, 请不要使用;
 */
@interface DrawPadAllExecute : LSOObject 

@property (readonly) CGFloat durationS;

@property (nonatomic,readonly) CGSize drawpadSize;
@property (nonatomic,assign) int encoderBitRate;


@property (nonatomic,readonly) int penCount;

-(id)initWithDrawPadSize:(CGSize)size durationS:(CGFloat)durationS;


@property(nullable, nonatomic,copy)  UIColor *backgroundColor;

-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset option:(LSOVideoOption * _Nullable)option;

-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset option:(LSOVideoOption *_Nullable)option startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;


-(LSOViewPen *)addViewPen:(UIView *)view ;


-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView;

-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView  startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;

-(LSOGifPen *)addGifPenWithURL:(NSURL *)gifUrl;


-(LSOGifPen *)addGifPenWithURL:(NSURL *)gifUrl startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;
-(LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset;
- (LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;

-(LSOMVPen *)addMVPen:(NSURL *)colorUrl withMask:(NSURL *)maskUrl  startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;
-(LSOMVPen *)addMVPen:(NSURL *)colorUrl withMask:(NSURL *)maskUrl;

-(LSOAECompositionPen *) addAeCompositionPen:(LSOAeCompositionAsset *)asset  startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;
-(LSOAECompositionPen *) addAeCompositionPen:(LSOAeCompositionAsset *)asset;

-(LSOVideoFramePen2 *)concatVideoFramePen2:(LSOVideoAsset *)asset option:(LSOVideoOption * _Nullable)option;

-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS;

-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS overLapTime:(CGFloat)overLapTimeS;

-(BOOL)start;
-(void)cancel;


-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

-(void)setFrameRate:(int)frameRate;
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);

@property(nonatomic, copy) void(^frameProgressBlock)(int frames);
@property(nonatomic, copy) void(^completionBlock)(NSString * _Nullable dstPath);

@property (nonatomic,readonly) BOOL isRunning;

-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;
@end

NS_ASSUME_NONNULL_END

