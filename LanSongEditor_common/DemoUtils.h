//
//  LanSongEditor_all
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"



//接下来3个demo UI部分使用, 您可以直接删除.
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "UIColor+Util.h"
#import "VideoPlayViewController.h"
#import "DemoProgressHUD.h"
#import "DemoTestButton.h"







#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define VIDEO_FOLDER @"videos"

#define LSOWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface DemoUtils : NSObject

+(void)showDialog:(NSString *)str;

+(void) showHUDToast:(NSString *)strHint;

+(void)startVideoPlayerVC:(UINavigationController*)nav dstPath:(NSString *)dstPath;


//20170522++
+ (void)setView:(UIView *)view toSizeWidth:(CGFloat)width;
+ (void)setView:(UIView *)view toOriginX:(CGFloat)x;
+ (void)setView:(UIView *)view toOriginY:(CGFloat)y;
+ (void)setView:(UIView *)view toOrigin:(CGPoint)origin;

+ (BOOL)createVideoFolderIfNotExist;
+ (NSString *)getVideoSaveFilePathString;
+ (NSString *)getVideoMergeFilePathString;
+ (NSString *)getVideoSaveFolderPathString;




/**
 根据容器大小, 计算应该显示多少到界面上;
 里面默认位置在:0,60;
 代码请自行修改,以满足你的需求;
 @param fullSize self.view.frame.size(当前ViewController的大小)
 @param padSize 容器大小
 @return 得到的容器显示view
 */
+(LanSongView2 *)createLanSongView:(CGSize)fullSize drawpadSize:(CGSize)padSize;

/**
 percent : 如果是竖屏的话, 高度占用全屏的多少大小;
 */
+(LanSongView2 *)createLanSongView:(CGSize)fullSize padSize:(CGSize)size percent:(float)percent;


+(LSOCompositionView *)createLSOCompositionView:(CGSize)fullSize drawpadSize:(CGSize)padSize;
/**
 创建LSOAeCompositionView;
 */
+(LSOAeCompositionView *)createAeCompositionView:(CGSize)fullSize drawpadSize:(CGSize)padSize;
/**
设置当前viewController竖屏
 */
+(void)setViewControllerPortrait;

/**
 设置当前viewController横屏
 */
+(void)setViewControllerLandscape;
/**
 在ViewController中调用, 设置当前屏幕的旋转角度.
 */
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;



/**
 打印json中的信息;
 */
+(void)printJsonInfo:(LSOAeView *)aeView;
@end

