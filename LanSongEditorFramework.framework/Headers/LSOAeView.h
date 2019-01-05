//
//  LSOAnimationView
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//  Dream Big.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSOKeypath.h"
#import "LSOValueDelegate.h"
#import "LSOAeText.h"
#import "LSOAeImage.h"
#import "LSOAeImageLayer.h"


typedef void (^LSOAnimationCompletionBlock)(BOOL animationFinished);

@interface LSOAeView : UIView

+(void)setGLanSongForcePrecomWidth:(CGFloat)w;
+(void)setGLanSongForcePrecomHeight:(CGFloat)h;
+(void)setLanSongAEWorkForPreview:(BOOL)is;
/**
 但输入的图片和 json中的图片宽高不同时,是否要强制等于输入图片的宽高;
 */
+(void)setGLanSongForceAdjustLayerSize:(BOOL)is;


/**
 从指定位置 增加动画文件json;
 从main bundle中找images文件夹;
 @param filePath json完整路径
 @return return value description
 */
+ (nonnull instancetype)animationWithFilePath:(nonnull NSString *)filePath NS_SWIFT_NAME(init(filePath:));

- (nonnull instancetype)initWithContentsOfURL:(nonnull NSURL *)url;

@property (nonatomic, strong) IBInspectable NSString * _Nullable animation;

- (void)setAnimationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(setAnimation(named:));

@property (nonatomic, readonly) BOOL isAnimationPlaying;

@property (nonatomic, assign) BOOL loopAnimation;

@property (nonatomic, assign) BOOL autoReverseAnimation;

/// Sets a progress from 0 - 1 of the animation. If the animation is playing it will stop and the completion block will be called.
/// The current progress of the animation in absolute time.
/// e.g. a value of 0.75 always represents the same point in the animation, regardless of positive
/// or negative speed.
@property (nonatomic, assign) CGFloat animationProgress;

@property (nonatomic, assign) CGFloat animationSpeed;

@property (nonatomic, readonly) CGFloat animationDuration;

/// Enables or disables caching of the backing animation model. Defaults to YES
@property (nonatomic, assign) BOOL cacheEnable;

@property (nonatomic, copy, nullable) LSOAnimationCompletionBlock completionBlock;



@property (nonatomic, assign) BOOL shouldRasterizeWhenIdle;


@property (nonatomic) CGFloat jsonWidth;
@property (nonatomic) CGFloat jsonHeight;

@property (nonatomic) CGFloat jsonFrameRate;//帧率
@property (nonatomic) int totalFrames;//总帧数.
@property (nonatomic) CGFloat jsonDuration; //总时长 =(结束帧数 - 开始帧数)/帧率; 单位秒;两位有效小数;
/**
 拿到json中所有图片的信息, 一个LSOAeImage对象数组;
 
 比如打印出来:
     for(LSOAeImage *info in aeView.imageInfoArray){
         LSLog(@"id:%@, width:%d %d, ame:%@",info.imgId,info.imgWidth,info.imgHeight,info.imgName);
     }
 */
@property (nonatomic) NSMutableArray *imageInfoArray;


/**
 拿到json中所有文本图层的文本信息,
 获取到的是 LSOAeText对象;
 用
     for (LSOAeText *tex in ret.textInfoArray) {
        NSLog(@"text is :%@", tex.textContents);
     }
 */
@property (nonatomic) NSMutableArray *textInfoArray;



/**
 当前json中所有图片图层的信息;
  获取到的是 LSOAeImageLayer对象;
 比如;
 for (LSOAeImageLayer *layer in view.imageLayerArray) {
 LSLog(@"id:%@,width:%d,height:%d,start frame:%d, end frame:%d",layer.imgName,layer.imgWidth,layer.imgHeight,layer.startFrame,layer.endFrame);
 }
 */
@property (nonatomic) NSMutableArray *imageLayerArray;


/**
不再使用.
 */
- (void)updateImage:(NSString *)assetID image:(UIImage*)image;
/**
 lansong++
 在开始执行前调用, 替换指定key的图片

 @param key "imag_0","image_1",这样的图片
 @param image 图片对象
 @return 替换成功返回YES
 */
-(BOOL)updateImageWithKey:(NSString*)key image:(UIImage *)image;

/**
 替换指定图片的视频;
 @param key json中的refId, image_0 image_1等;
 @param url 视频文件路径
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageWithKey:(NSString*)key url:(NSURL *)url;

/**
 当设置updateVideoImageWithKey后, 你可以通过这个来调整视频中每一帧;

 @param key json中的refId, image_0 image_1等, 给哪个id设置回调
 @param frameUpdateBlock 视频每更新一帧, 会直接执行这里的回调, 注意回调返回的是UIImage * 类型
 @return 可以设置返回YES
 */
- (BOOL)setVideoImageFrameBlock:(NSString *)key updateblock:(UIImage *(^)(NSString *imgId,CGFloat framePts,UIImage *image))frameUpdateBlock;


/**
 更新文字, 用图层的名字来更新;

 @param layerName 图层名字
 @param newText 新的文字;
 @return 更新成功返回YES
 */
- (BOOL) updateTextWithLayerName:(NSString *)layerName newText:(NSString *)newText;
/**
 更新文本
 @param textText: json中的文字; 可以用textInfoArray获得;
 @param newText: 新的文字
 @return 更新成功返回YES;
 */
- (BOOL) updateTextWithOldText:(NSString *)text newText:(NSString *)newText;


/**
 设置文本的字体库;
 
 @param text json中的文字; 可以用textInfoArray获得;
 @param font 在包中的字体;
 @return
 */
- (BOOL) updateFontWithText:(NSString *)text font:(NSString *)font;

- (void)playToProgress:(CGFloat)toProgress
        withCompletion:(nullable LSOAnimationCompletionBlock)completion;

/*
 * Plays the animation from specific progress to a specific progress
 * The animation will start from its current position..
 * If loopAnimation is YES the animation will loop from the startProgress to the endProgress indefinitely
 * If loopAnimation is NO the animation will stop and the completion block will be called.
 */
- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress
          withCompletion:(nullable LSOAnimationCompletionBlock)completion;

/*
 * Plays the animation from its current position to a specific frame.
 * The animation will start from its current position.
 * If loopAnimation is YES the animation will loop from beginning to toFrame indefinitely.
 * If loopAnimation is NO the animation will stop and the completion block will be called.
 */
- (void)playToFrame:(nonnull NSNumber *)toFrame
     withCompletion:(nullable LSOAnimationCompletionBlock)completion;

/*
 * Plays the animation from specific frame to a specific frame.
 * The animation will start from its current position.
 * If loopAnimation is YES the animation will loop start frame to end frame indefinitely.
 * If loopAnimation is NO the animation will stop and the completion block will be called.
 */
- (void)playFromFrame:(nonnull NSNumber *)fromStartFrame
              toFrame:(nonnull NSNumber *)toEndFrame
       withCompletion:(nullable LSOAnimationCompletionBlock)completion;


/**
 * Plays the animation from its current position to the end of the animation.
 * The animation will start from its current position.
 * If loopAnimation is YES the animation will loop from beginning to end indefinitely.
 * If loopAnimation is NO the animation will stop and the completion block will be called.
 **/
- (void)playWithCompletion:(nullable LSOAnimationCompletionBlock)completion;

- (void)play;
- (void)pause;
- (void)stop;
- (void)setProgressWithFrame:(nonnull NSNumber *)currentFrame;
- (void)forceDrawingUpdate;
- (void)logHierarchyKeypaths;

/*!
 @brief Sets a LSOValueDelegate for each animation property returned from the LSOKeypath search. LSOKeypath matches views inside of LSOAnimationView to their After Effects counterparts. The LSOValueDelegate is called every frame as the animation plays to override animation values. A delegate can be any object that conforms to the LSOValueDelegate protocol, or one of the prebuilt delegate classes found in LSOBlockCallback, LSOInterpolatorCallback, and LSOValueCallback.

 @discussion
 Example that sets an animated stroke to Red using a LSOColorValueCallback.
 @code
 LSOKeypath *keypath = [LSOKeypath keypathWithKeys:@"Layer 1", @"Ellipse 1", @"Stroke 1", @"Color", nil];
 LSOColorValueCallback *colorCallback = [LSOColorBlockCallback withColor:[UIColor redColor]];
 [animationView setValueCallback:colorCallback forKeypath:keypath];
 @endcode

 See the documentation for LSOValueDelegate to see how to create LSOValueCallbacks. A delegate can be any object that conforms to the LSOValueDelegate protocol, or one of the prebuilt delegate classes found in LSOBlockCallback, LSOInterpolatorCallback, and LSOValueCallback.

 See the documentation for LSOKeypath to learn more about how to create keypaths.

 */
- (void)setValueDelegate:(id<LSOValueDelegate> _Nonnull)delegates
              forKeypath:(LSOKeypath * _Nonnull)keypath;

/*!
 @brief returns the string representation of every keypath matching the LSOKeypath search.
 */
- (nullable NSArray *)keysForKeyPath:(nonnull LSOKeypath *)keypath;

/*!
 @brief Converts a CGPoint from the Animation views top coordinate space into the coordinate space of the specified renderable animation node.
 */
- (CGPoint)convertPoint:(CGPoint)point
         toKeypathLayer:(nonnull LSOKeypath *)keypath;

/*!
 @brief Converts a CGRect from the Animation views top coordinate space into the coordinate space of the specified renderable animation node.
 */
- (CGRect)convertRect:(CGRect)rect
       toKeypathLayer:(nonnull LSOKeypath *)keypath;

/*!
 @brief Converts a CGPoint to the Animation views top coordinate space from the coordinate space of the specified renderable animation node.
 */
- (CGPoint)convertPoint:(CGPoint)point
       fromKeypathLayer:(nonnull LSOKeypath *)keypath;

/*!
 @brief Converts a CGRect to the Animation views top coordinate space from the coordinate space of the specified renderable animation node.
 */
- (CGRect)convertRect:(CGRect)rect
     fromKeypathLayer:(nonnull LSOKeypath *)keypath;

/*!
 @brief Adds a UIView, or NSView, to the renderable layer found at the Keypath
 */
- (void)addSubview:(nonnull UIView *)view
    toKeypathLayer:(nonnull LSOKeypath *)keypath;

/*!
 @brief Adds a UIView, or NSView, to the parentrenderable layer found at the Keypath and then masks the view with layer found at the keypath.
 */
- (void)maskSubview:(nonnull UIView *)view
     toKeypathLayer:(nonnull LSOKeypath *)keypath;

#if !TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
@property (nonatomic) LSOViewContentMode contentMode;
#endif

/*!
 @brief Sets the keyframe value for a specific After Effects property at a given time. NOTE: Deprecated. Use setValueDelegate:forKeypath:
 @discussion NOTE: Deprecated and non functioning. Use setValueCallback:forKeypath:
 @param value Value is the color, point, or number object that should be set at given time
 @param keypath NSString . separate keypath The Keypath is a dot separated key path that specifies the location of the key to be set from the After Effects file. This will begin with the Layer Name. EG "Layer 1.Shape 1.Fill 1.Color"
 @param frame The frame is the frame to be set. If the keyframe exists it will be overwritten, if it does not exist a new linearly interpolated keyframe will be added
 */
- (void)setValue:(nonnull id)value
      forKeypath:(nonnull NSString *)keypath
         atFrame:(nullable NSNumber *)frame __deprecated;

/*!
 @brief Adds a custom subview to the animation using a LayerName from After Effect as a reference point.
 @discussion NOTE: Deprecated. Use addSubview:toKeypathLayer: or maskSubview:toKeypathLayer:
 @param view The custom view instance to be added

 @param layer The string name of the After Effects layer to be referenced.

 @param applyTransform If YES the custom view will be animated to move with the specified After Effects layer. If NO the custom view will be masked by the After Effects layer
 */
- (void)addSubview:(nonnull UIView *)view toLayerNamed:(nonnull NSString *)layer
    applyTransform:(BOOL)applyTransform __deprecated;

/*!
 @brief Converts the given CGRect from the receiving animation view's coordinate space to the supplied layer's coordinate space If layerName is null then the rect will be converted to the composition coordinate system. This is helpful when adding custom subviews to a LSOAnimationView
 @discussion NOTE: Deprecated. Use convertRect:fromKeypathLayer:
 */
- (CGRect)convertRect:(CGRect)rect
         toLayerNamed:(NSString *_Nullable)layerName __deprecated;


+ (nonnull instancetype)animationFromJSON:(nullable NSDictionary *)animationJSON inBundle:(nullable NSBundle *)bundle NS_SWIFT_NAME(init(json:bundle:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(init(name:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle NS_SWIFT_NAME(init(name:bundle:));
+ (nonnull instancetype)animationFromJSON:(nonnull NSDictionary *)animationJSON NS_SWIFT_NAME(init(json:));
@end
