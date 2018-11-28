

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import <UIKit/UIKit.h>
#import "LanSongLog.h"

@protocol LanSongMp3ToAACDelegate;

@interface LanSongMp3ToAAC : NSObject


/**
 MP3格式转AAC格式的构造函数.

 支持wav转换.
 @param delegate 完成监听, 进度监听,错误监听的回调
 @param srcPath MP3源文件或 wav文件,
 @param dstPath 转换后的AAC/M4A 文件的保存路径, 绝对路径,后缀是m4a的文件
 @return 创建好的对象
 */
- (id)initWithDelegate:(id<LanSongMp3ToAACDelegate>)delegate source:(NSString*)srcPath destination:(NSString*)dstPath;

/**
 初始化
 */
- (id)initWithSource:(NSString*)source dstPath:(NSString*)dstPath;
/**
 开始运行, 内部会开启一个线程来运行.
 */
- (void)start;

/**
 阻塞执行模式, 调用后, 直接执行这里, 直到结束退出为止;
 */
-(void)startExecute;
/**
  暂停
 */
- (void)pause;

/**
 恢复
 */
- (void)resume;
/**
停止
 */
- (void)stop;
@end

//---------------以下是监听回调.

@protocol LanSongMp3ToAACDelegate <NSObject>

/**
 转换结束的回调

 @param convert
 */
- (void)LanSongMp3ToAACDelegateCompleted:(LanSongMp3ToAAC*)convert;

@optional
/**
 转换错误的回调[可选, 当前未使用]
 
 @param converter 对象
 @param error 错误描述
 */
- (void)LanSongMp3ToAACDelegateError:(LanSongMp3ToAAC*)converter error:(NSError*)error;
/**
 进度监听[可选]
 (一般很快完成, 也不建议使用.)
 @param converter 当前对象
 @param progress 进度值,  从0.0---1.0
 */
- (void)LanSongMp3ToAACDelegateProgress:(LanSongMp3ToAAC*)converter progress:(CGFloat)progress;

/*
 应用举例
 -------------------------------------------------------------------------------------------------------------------------
 {
 NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *srcPath=[[NSBundle mainBundle] pathForResource:@"niliuchenghe" ofType:@"mp3"];
 
 LanSongMp3ToAAC *audioConverter = [[LanSongMp3ToAAC alloc] initWithDelegate:self
 source:srcPath
 destination:[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"mytest.m4a"]];
 LSLog(@"开始转换.....");
 [audioConverter start];
 }
 -(void)LanSongMp3ToAACDelegateCompleted:(LanSongMp3ToAAC*)convert;
 {
 LSLog(@"转换完成");
 }
 -(void)LanSongMp3ToAACDelegateProgress:(LanSongMp3ToAAC *)converter progress:(CGFloat)progress
 {
 LSLog(@"转换 进度是:%f",progress);
 }
 */
@end
