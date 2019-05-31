//
//  LSOEditMode.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/10/16.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOEditMode : NSObject
/**
 初始化,输入视频
 
 @param srcInput 输入视频
 @return
 */
-(id)initWithURL:(NSURL *)url;
/**
 开始导入;
 导入成编码模式
 */
-(BOOL)startImport;


/**
 [不建议使用,
 
 sdk当前默认所有的视频编码后,都是普通视频;]
 开始导出, 导出为普通视频;
 @return
 */
-(BOOL)startExport;

/**
 进度回调,
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 如要工作在主线程,请使用:
 返回的是百分比 0--1.0;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */

@property(nonatomic, copy) void(^progressBlock)(CGFloat percent);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);


+(void)testDecoder:(NSURL *)url TAG:(NSString *)tag;
@end
/*
 测试代码:
 LSOEditMode *editMode;
 -(void)testEditMode:(NSURL *)sampleURL
 {
     editMode=[[LSOEditMode alloc] initWithURL:sampleURL];
     [editMode setProgressBlock:^(CGFloat percent) {
        LSOLog(@"edit mode progress :%f",percent);
     }];
     [editMode setCompletionBlock:^(NSString * _Nonnull dstPath) {
        [MediaInfo checkFile:dstPath];
     }];
     [editMode startImport];
 
 }
 */
NS_ASSUME_NONNULL_END
