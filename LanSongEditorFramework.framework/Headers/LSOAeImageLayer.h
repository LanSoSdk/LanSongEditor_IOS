//
//  LSOAeImageLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/25.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSOAEVideoSetting.h"
#import "LSOAEVideoAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAeImageLayer : NSObject





//图层名字
@property (nonatomic,  readonly, strong, nullable) NSString *layerName;

/**
 在当前合成里的开始帧
 [如果图层在预合成里,则是相对于预合成的开始帧]
 */
@property (nonatomic, readonly) CGFloat startFrame;

/**
  在当前合成里的结束帧
 [如果图层在预合成里,则是相对于预合成的开始帧]
 */
@property (nonatomic, readonly) CGFloat endFrame;


/**
 当前图片图层的时长.单位:秒;
 计算原理是:_endFrame - _startFrame/frameRate
 */
@property (nonatomic, readonly) CGFloat durationS;


//图片图层中的图片名字
@property (nonatomic, readonly, nullable) NSString *imgName;

//图片图层中的图片对应的id号.
@property (nonatomic, readonly, nullable) NSString *imgId;

//图片的宽高;
@property (nonatomic, readonly) CGFloat imgWidth;
@property (nonatomic, readonly) CGFloat imgHeight;

//当前json的帧率
@property (nonatomic, readonly) CGFloat jsonFrameRate;

-(void)setImage:(UIImage *)image;
-(void)setImageURL:(NSURL *)imageURL needCrop:(BOOL)needCrop;

-(void)setImageVideo:(NSURL *)image setting:(nullable LSOAEVideoSetting *)setting;
-(void)setVideoFrameUpdateBlock:(UIImage *(^)(NSString *imgId,CGFloat framePts,UIImage *image))frameUpdateBlock;



/**
 设置在视频界面的时候的回调.

 @param frameUpdateBlock 回调, 里面的3个 方法分别是,这一帧的时间戳,图像, 要顺时针旋转的角度
 */
-(void)setVideoDecoderFrameBlock:(UIImage *(^)(CGFloat framePts,CIImage *image,CGFloat  angle))frameUpdateBlock;
/**********************一下为内部使用******************************************/
- (instancetype _Nonnull)initWithID:(CALayer *)refId jsonFrameRate:(float)frameRate;
-(void)releaseImageLayer;
@end

NS_ASSUME_NONNULL_END
