//
//  LSOObject.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/5/13.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"
#import "LSOFileUtil.h"

NS_ASSUME_NONNULL_BEGIN

//老版本的API 各种图层. 已经废弃;
typedef NS_ENUM(NSUInteger, PenTpye) {
    kNullPen,
    kVideoPen,
    kVideoFramePen,
    kBitmapPen,
    kViewPen,
    kAEViewPen,
    kCameraPen,
    kMVPen,
    kCALayerPen,
    kDataPen,
    kSubPen
};

//新版本的API的各种图层;
typedef NS_ENUM(NSUInteger, LSOLayerType2) {
    kLSONullLayer,
    kLSOConcatVideoLayer,
    kLSOConcatImageLayer,
    kLSOVideoLayer,
    kLSOAEViewLayer,
    kLSOMVLayer,
    kLSOImageLayer,
    kLSOGIFLayer,
    kLSOImageArrayLayer
};


//图层位置枚举;
typedef enum : NSInteger {
    kLSOPositionNONE,
    kLSOPositionTop,
    kLSOPositionBottom,
    kLSOPositionLeft,
    kLSOPositionRight,
    
    kLSOPositionLeftTop,
    kLSOPositionLeftBottom,
    kLSOPositionRightTop,
    kLSOPositionRightBottom,
    kLSOPositionCenter,
    
} LSOPositionType;


//缩放枚举;
typedef enum : NSInteger {
    /**
     * 无缩放形式.则内部会根据不同的素材,采用默认形式;
     */
    kLSOScaleNONE,
    /**
     * 原始大小
     * 直接放入, 不做任意处理;
     */
    kLSOScaleOriginal,
    /**
     * 忽略百分比,把宽度等于容器的宽度, 高度等于容器的高度,填满整个容器.
     * 这样有些画面可能会变形;
     */
    kLSOScaleFillComposition,
    
    /**
     * 匹配放入到容器中;
     * 等比例填满整个容器, 把多的部分显示到容器的外面去;
     */
    kLSOScaleCropFillComposition,
    /**
     * 视频缩放模式
     * 如果视频宽度大于高度, 则宽度和容器对齐, 然后等比例调整高度;
     * 如果高度大于宽度, 则把高度和容器的边缘对齐, 然后调整宽度;
     */
    kLSOScaleVideoScale,
    
} LSOScaleType;


typedef enum : NSInteger {
    kLSOPenTop,
    kLSOPenBottom,
    kLSOPenLeft,
    kLSOPenRight,
    
    
    kLSOPenLeftTop,
    kLSOPenLeftBottom,
    kLSOPenRightTop,
    kLSOPenRightBottom,
    kLSOPenCenter,
} LSOPosition;


@interface LSOObject : NSObject

//给当前类做一个标记. TAG;
/**
 类似UIView中的id,
 比如你增加了多个图层, 为了区分不同的图层, 可以给图层增加一个tag 比如@"#1", 比如"firstLayer"
 */
@property (assign,readwrite) NSObject *lsoTag;
@property (assign,readwrite) BOOL lock;
/**
 创建一个queue,
 使用方法是:
 dispatch_queue_t queue=createQueueLSO(self);
 */
dispatch_queue_t createQueueLSO(NSObject *object);

/**
 同步执行一个 queue;
 */
void runSyncQueueLSO(dispatch_queue_t queue, void (^block)(void));

/**
 异步执行一个 queue;
 */
void runAsyncQueueLSO(dispatch_queue_t queue, void (^block)(void));


/*******************一下内部使用 LSDEMO_DELETE********************************************************************/ //LSDEMO
//LSDEMO_DELETE
-(id)getId1BySDK; //LSDEMO
-(id)getId2BySDK; //LSDEMO
-(void)releaseLSO; //LSDEMO
+(CGSize)convertScaleType:(LSOScaleType)scaleType assetSize:(CGSize)assetSize compSize:(CGSize)compSize; //LSDEMO
+(CGPoint )convertPositionType:(LSOPositionType)positionType  assetSize:(CGSize)scaleSize compSize:(CGSize)compSize; //LSDEMO
/*******************内部使用 END  LSDEMO_DELETE********************************************************************/ //LSDEMO


@end

NS_ASSUME_NONNULL_END
