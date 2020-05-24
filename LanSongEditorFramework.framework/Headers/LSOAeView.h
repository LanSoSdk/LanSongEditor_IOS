//
//  LSOAnimationView
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//  Dream Big.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSOKeypath.h"
#import "LSOAeText.h"
#import "LSOAeImage.h"
#import "LSOAeImageLayer.h"
#import "LSOAEVideoSetting.h"




NS_ASSUME_NONNULL_BEGIN

typedef void (^LSOAnimationCompletionBlock)(BOOL animationFinished);


@interface LSOAeView : UIView


 

/**
 解析json得到新的LSOAeView对象;
 
 @param path json的完整路径
 @return 返回解析后的LSOAeView (可以得到宽高,图片数量,文字信息等各种需要替换的内容)
 */
+(LSOAeView *)parseJsonWithPath:(NSString *)path;

/**
 解析json得到新的LSOAeView对象;
 
 [如果您要对json加密,则在解密后,是放在内存中的数据,则此方法增加]
 @param jsonData NSData格式的json数据
 @return 返回解析后的LSOAeView (可以得到宽高,图片数量,文字信息等各种需要替换的内容)
 */
+(LSOAeView *)parseJsonWithData:(NSData *)jsonData;



@property (nonatomic) CGFloat jsonWidth;
@property (nonatomic) CGFloat jsonHeight;

@property (nonatomic) CGFloat jsonFrameRate;//帧率
@property (nonatomic) int totalFrames;//总帧数.
@property (nonatomic) CGFloat jsonDuration; //总时长 =(结束帧数 - 开始帧数)/帧率; 单位秒;两位有效小数;


/// 是否已经走到json的最后一帧;
/// 第一帧是0; 最后一直是 totalFrames -1;
@property (readonly) BOOL isReachEndFrame;

/**

 
 拿到json中所有图片的信息, 一个LSOAeImage对象数组;
 比如打印出来:
     for(LSOAeImage *info in aeView.imageInfoArray){
         LSOLog(@"id:%@, width:%d %d, ame:%@",info.imgId,info.imgWidth,info.imgHeight,info.imgName);
     }
 */
@property (nonatomic, readonly) NSMutableArray *imageInfoArray;


/**
 拿到json中所有文本图层的文本信息,
 获取到的是 LSOAeText对象;
 用
     for (LSOAeText *tex in ret.textInfoArray) {
        NSLog(@"text is :%@", tex.textContents);
     }
 */
@property (nonatomic,readonly) NSMutableArray *textInfoArray;



/**
 当前json中所有图片图层的信息;
 imageInfoArray-->图片信息;
 imageLayerArray-->图层信息, 一个图片可以放到不同的图层中;
  获取到的是 LSOAeImageLayer对象;
 
 数组里的每个成员排序规则是: 先按照开始帧, 如果开始帧相等则按照id;
 比如;
 for (LSOAeImageLayer *layer in view.imageLayerArray) {
 LSOLog(@"id:%@,width:%d,height:%d,start frame:%d, end frame:%d",layer.imgName,layer.imgWidth,layer.imgHeight,layer.startFrame,layer.endFrame);
 }
 */
@property (nonatomic) NSMutableArray *imageLayerArray;


/**
 在开始执行前调用, 替换指定key的图片
[图片请不要大于720x1280]
 @param key "json中的图片ID号, image_0 image_1等;
 @param image 图片对象
 @return 替换成功返回YES
 */
-(BOOL)updateImageWithKey:(NSString*)key image:(UIImage *)image;
/**
 替换图片

[图片请不要大于720x1280]
 @param key "json中的图片ID号, image_0 image_1等;
 @param image 图片对象
 @param needCrop 如果替换的图片和json的图片宽高不一致,是否SDK内部裁剪(内部是居中裁剪);
 @return 替换成功返回YES
 */
-(BOOL)updateImageWithKey:(NSString*)key image:(UIImage *)image needCrop:(BOOL)needCrop;


/*
 json中的每个图片有一个唯一的ID, 根据id来替换指定json中的图片.
@param key "json中的图片ID号, image_0 image_1等;
@param imageURL 您选择的图片路径;
 */
-(BOOL)updateImageWithKey:(NSString*)key imageURL:(NSURL *)imageURL;

/*
 json中的每个图片有一个唯一的ID, 根据id来替换指定json中的图片.
 @param key "json中的图片ID号, image_0 image_1等;
 @param imageURL 您选择的图片路径;
 @param needCrop 如果您输入的图片宽高和 json中的图片宽高不成比例,是否要裁剪
*/
-(BOOL)updateImageWithKey:(NSString*)key imageURL:(NSURL *)imageURL needCrop:(BOOL)needCrop;


/// 根据json中的图片名字来替换指定json中的图片.
/// @param name json中的图片名字,如果你在导出的时候, 选中保留原始名字,则会在aeView加载json后,会打印原始名字字符串
/// @param imageURL 要替换的图片路径
-(BOOL)updateImageByName:(NSString*)name imageURL:(NSURL *)imageURL;

/// 根据json中的图片名字来替换指定json中的图片.
/// @param name json中的图片名字,如果你在导出的时候, 选中保留原始名字,则会在aeView加载json后,会打印原始名字字符串
/// @param imageURL 要替换的图片路径
/// @param needCrop 如果您输入的图片宽高和 json中的图片宽高不成比例,是否要裁剪
-(BOOL)updateImageByName:(NSString*)name imageURL:(NSURL *)imageURL needCrop:(BOOL)needCrop;


/**
 替换指定图片的视频;
 
 @param key json中的图片ID号, image_0 image_1等;
 @param url 视频文件路径
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageWithKey:(NSString*)key url:(NSURL *)url;

/**
 替换指定图片中的视频

 @param key json中的图片ID号, image_0 image_1等;
 @param url 视频文件路径
 @param setting 视频文件在处理中的选项设置;
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageWithKey:(NSString*)key url:(NSURL *)url setting:(LSOAEVideoSetting *)setting;

/**
 替换图片
 根据Ae中的图片名字替换对应的图片;
 [图片请不要大于720x1280]
 @param name "json中的图片名字;
 @param image 图片对象
 @return 替换成功返回YES
 */
-(BOOL)updateImageByName:(NSString*)name image:(UIImage *)image LSO_DELPRECATED;

/**
 替换图片
 根据Ae中的图片名字替换对应的图片;
 [图片请不要大于720x1280]
 @param name "json中的图片名字;
 @param image 图片对象
 @param needCrop 如果替换的图片和json的图片宽高不一致,是否SDK内部裁剪(内部是居中裁剪);
 @return 替换成功返回YES
 */
-(BOOL)updateImageByName:(NSString*)name image:(UIImage *)image needCrop:(BOOL)needCrop LSO_DELPRECATED;

/**
 根据名字 把原来显示图片的地方替换为视频;
 
 @param name "json中的图片名字;
 @param url 视频文件路径
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageByName:(NSString*)name url:(NSURL *)url LSO_DELPRECATED;
/**
 根据名字 把原来显示图片的地方替换为视频;
 
  @param name "json中的图片名字;
 @param url 视频文件路径
 @param setting 视频文件在处理中的选项设置;
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageByName:(NSString*)name url:(NSURL *)url setting:(LSOAEVideoSetting *)setting LSO_DELPRECATED;
/**
 当设置updateVideoImageWithKey后, 你可以通过这个来调整视频中每一帧;

 [此方法运行在SDK的渲染线程.]
 @param key json中的refId, image_0 image_1等, 给哪个id设置回调
 @param frameUpdateBlock 视频每更新一帧, 会直接执行这里的回调, 注意回调返回的是:图片id, 当前帧的时间戳, UIImage图片.您在处理返回的图片,尽量给您的大小一直,或等比例.
 @return 可以设置返回YES
 */
- (BOOL)setVideoImageFrameBlock:(NSString *)key updateblock:(UIImage *(^)(NSString *imgId,CGFloat framePts,UIImage *image))frameUpdateBlock;

/**
 设置在视频解码时的回调.

 内部是异步解码线程,解码后放到到array中,再使用的时候,取走.
 
 @param key json中的refId, image_0 image_1等, 给哪个id设置回调
 @param frameUpdateBlock 视频解码一帧,会调用这个方法,让您设置, 回调里的三个方法分别是, 时间戳, 图像, 要旋转的顺时针角度(您一定要旋转这个角度才可以处理.), 回调返回的是UIImage, 我们内部会在释放后释放.
 @return 设置好返回YES
 */
- (BOOL)setVideoDecoderFrameBlock:(NSString *)key updateblock:(UIImage *(^)(CGFloat framePts,CIImage *image,CGFloat angle))frameUpdateBlock;
/**
 更新文字, 用图层的名字来更新;

 @param layerName 图层名字
 @param newText 新的文字;
 @return 更新成功返回YES
 */
- (BOOL) updateTextWithLayerName:(NSString *)layerName newText:(NSString *)newText;
/**
 更新文本
 @param textText: json中的文字; 可以用textInfoArray获得;LSOAeText 中的 textContents变量
 @param newText: 新的文字
 @return 更新成功返回YES;
 */
- (BOOL) updateTextWithOldText:(NSString *)text newText:(NSString *)newText;
/**
 设置文本的字体库;
 
 内部使用原理是:设置到CATextLayer.font中;
 @param text json中的文字段; 用textInfoArray获得;  是LSOAeText 中的 textContents变量
 @param font 文字用到的字体的绝对路径; 测试的有:TTF格式, otf格式;
 @return
 */
- (BOOL)updateFontWithText:(NSString *)text fontPath:(NSString *)fontPath;


/**
设置文本的字体

 @param text 文字; 用textInfoArray获得;  是LSOAeText 中的 textContents变量
 @param font 要设置的字体
 @return 生成好返回YES; 没有这个text返回NO;
 */
- (BOOL)updateFontWithText:(NSString *)text font:(UIFont *)font;

/**********************************以下SDK内部使用, 请勿使用********************************************************************/
//LSDEMO start
+(void)setGLanSongForcePrecomWidth:(CGFloat)w;
+(void)setGLanSongForcePrecomHeight:(CGFloat)h;
+(void)setLanSongAEWorkForPreview:(BOOL)is;
+ (nonnull instancetype)animationWithFilePath:(nonnull NSString *)filePath NS_SWIFT_NAME(init(filePath:));
- (nonnull instancetype)initWithContentsOfURL:(nonnull NSURL *)url;
@property (nonatomic, strong) IBInspectable NSString * _Nullable animation;

- (void)setAnimationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(setAnimation(named:));
@property (nonatomic, readonly) BOOL isAnimationPlaying;
@property (nonatomic, assign) BOOL loopAnimation;
@property (nonatomic, assign) BOOL autoReverseAnimation;
@property (nonatomic, assign) CGFloat animationProgress;
@property (nonatomic, assign) CGFloat animationSpeed;
@property (nonatomic, readonly) CGFloat animationDuration;
@property (nonatomic, assign) BOOL cacheEnable;
@property (nonatomic, copy, nullable) LSOAnimationCompletionBlock completionBlock;
@property (nonatomic, assign) BOOL shouldRasterizeWhenIdle;
- (void)playToProgress:(CGFloat)toProgress
        withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress
          withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playToFrame:(nonnull NSNumber *)toFrame
     withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playFromFrame:(nonnull NSNumber *)fromStartFrame
              toFrame:(nonnull NSNumber *)toEndFrame
       withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playWithCompletion:(nullable LSOAnimationCompletionBlock)completion;

- (void)play;
- (void)pause;
- (void)stop;
- (void)setProgressWithFrame:(nonnull NSNumber *)currentFrame;
- (void)forceDrawingUpdate;
- (void)logHierarchyKeypaths;
-(void)clearAllLayerImage;

//- (void)setValueDelegate:(id<LSOValueDelegate> _Nonnull)delegates
//              forKeypath:(LSOKeypath * _Nonnull)keypath;
- (nullable NSArray *)keysForKeyPath:(nonnull LSOKeypath *)keypath;
- (CGPoint)convertPoint:(CGPoint)point
         toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGRect)convertRect:(CGRect)rect  toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGPoint)convertPoint:(CGPoint)point fromKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGRect)convertRect:(CGRect)rect fromKeypathLayer:(nonnull LSOKeypath *)keypath;

- (void)addSubview:(nonnull UIView *)view toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (void)addSubLayer:(nonnull CALayer *)layer;
- (void)maskSubview:(nonnull UIView *)view toKeypathLayer:(nonnull LSOKeypath *)keypath;

#if !TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
@property (nonatomic) LSOViewContentMode contentMode;
#endif

- (void)setValue:(nonnull id)value forKeypath:(nonnull NSString *)keypath atFrame:(nullable NSNumber *)frame __deprecated;

- (void)addSubview:(nonnull UIView *)view toLayerNamed:(nonnull NSString *)layer
    applyTransform:(BOOL)applyTransform __deprecated;

-(void)processImageAtFrameBeforeUpdate:(int)frameIndex;
-(void)updateImageWithKeyForce:(NSString*)key image:(UIImage *)image;


- (CGRect)convertRect:(CGRect)rect toLayerNamed:(NSString *_Nullable)layerName __deprecated;
+ (nonnull instancetype)animationFromJSON:(nullable NSDictionary *)animationJSON inBundle:(nullable NSBundle *)bundle NS_SWIFT_NAME(init(json:bundle:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(init(name:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle NS_SWIFT_NAME(init(name:bundle:));
+ (nonnull instancetype)animationFromJSON:(nonnull NSDictionary *)animationJSON NS_SWIFT_NAME(init(json:));
+ (nonnull instancetype)animationWithFileData:(nonnull NSData *)fileData;

//LSDEMO end
/**********************************以下SDK内部使用, 请勿使用********************************************************************/


@end
NS_ASSUME_NONNULL_END
