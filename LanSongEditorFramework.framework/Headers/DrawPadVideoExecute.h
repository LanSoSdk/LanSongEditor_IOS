//
//  DrawPadVideoExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/7.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView2.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LanSong.h"

@interface DrawPadVideoExecute : NSObject

@property (nonatomic,readonly)MediaInfo *mediaInfo;
@property (nonatomic)   LanSongMovie *videoPen;
@property (nonatomic,assign) CGSize drawpadSize;


/**
 初始化

 @param videoPath 输入的视频文件
 @return 返回构造对象
 */
-(id)initWithURL:(NSURL *)videoPath;
-(id)initWithPath:(NSString *)videoPath;

/**
 增加UI图层;
 @param view UI图层
 @param from 这个UI来自界面; 当前请设置为YES
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

-(BitmapPen *)addBitmapPen:(UIImage *)image;

-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

-(void)removePen:(Pen *)pen;

/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;

/**
 进度回调,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

-(void)switchFilter:(LanSongOutput <LanSongInput> *)filter;

/**
 滤镜级联, 叠加;
 把最后的滤镜输入到这里;
 */
-(void)switchFilterStartWith:(LanSongOutput <LanSongInput> *)startFilter  end:(LanSongOutput <LanSongInput> *)endFilter;

-(void)switchFilter:(LanSongTwoInputFilter *)filter secondInput:(LanSongOutput *)secondFilter;
@end
