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

NS_ASSUME_NONNULL_BEGIN

@interface LSOAeImageLayer : NSObject



- (instancetype _Nonnull)initWithID:(CALayer *)refId;

//图层名字
@property (nonatomic,  readonly, strong, nullable) NSString *layerName;

//图层的开始帧数
@property (nonatomic, readonly) int startFrame;

//图层的结束帧数;
@property (nonatomic, readonly) int endFrame;

//图片图层中的图片名字
@property (nonatomic, readonly, nullable) NSString *imgName;

//图片图层中的图片对应的id号.
@property (nonatomic, readonly, nullable) NSString *imgId;

//图片的宽高;
@property (nonatomic, readonly) int imgWidth;
@property (nonatomic, readonly) int imgHeight;



//内部使用;
-(void)setImage:(UIImage *)image;
-(void)setImageVideo:(NSURL *)image setting:(nullable LSOAEVideoSetting *)setting;
@end

NS_ASSUME_NONNULL_END
