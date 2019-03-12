//
//  LSOAssetInfo.h
//  SimpleVideoFileFilter
//
//  Created by sno on 16/8/17.
//  Copyright © 2016年 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LSOAssetInfo : NSObject

/**
  视频本身的宽度.
 */
@property(readwrite, nonatomic) CGFloat width;


/**
 视频本身的高度
 */
@property(readwrite, nonatomic) CGFloat height;

@property(readwrite, nonatomic) CGFloat duration;

@property(readwrite, nonatomic) CGFloat frameRate;

@property(readwrite, nonatomic) CGFloat bitrate ;


@property(nonatomic, readonly) NSString *filePath;
@property(nonatomic, readonly) NSString *fileName;
@property(nonatomic, readonly) NSString *fileSuffix;

@property(readwrite, nonatomic) BOOL hasVideo;
@property(readwrite, nonatomic) BOOL hasAudio;
@property(nonatomic,readonly) int videoAngle;


//一下拿不到;
//@property(nonatomic) int aSampleRate;
//@property(nonatomic) int aChannels;
//@property(nonatomic) int64_t aBitRate;

- (id)initWithURL:(NSURL *)url;

- (BOOL)prepare;

@end
