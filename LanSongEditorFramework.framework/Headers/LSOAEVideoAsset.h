//
//  LSOAEVideoAsset.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/1/16.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOAsset.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSOAEVideoAsset : LSOAsset




/// 初始化, 如果失败则返回 nil
/// @param url 视频的路径
-(id)initWithURL:(NSURL *)url;

-(BOOL)prepare;

//------------视频的常见属性;
@property (nonatomic,readonly) NSURL *videoURL;
/**
 显示的宽度;
 */
@property(nonatomic,readonly) CGFloat width;
/**
 显示时的高度;
 */
@property(nonatomic,readonly) CGFloat height;
/**
 视频时长,单位秒;
 */
@property(nonatomic,readonly) CGFloat durationS;


/**
 当前处理每一帧的时间戳(进度);
 单位秒,
 */
@property(readonly) CGFloat progressS;

///  当前压缩是否在进行;
@property(readonly) BOOL running;

/**
 开始压缩.
 内部会开启一个线程, 在线程中异步执行;
 你可以通过进度 block 和完成 block得到执行的进度;
 */
-(BOOL)startCompress;
/**
 开始压缩
 阻塞执行. 只有全部执行完毕后, 才执行下一行;
 */
-(BOOL)startCompressExecute;

/**
 取消执行;
 只是对startCompress有效果;
 会等待一点时间, 等线程彻底退出;
 */
-(void)cancel;
/**
 导出进度;
 progress 是当前时间戳, percent 进度百分比(0--1);
 
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
        ---CODE-----
 });
 */
@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);

/**
 导出完成
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
        ---CODE-----
 });
 */
@property(nonatomic, copy) void(^exportCompletionBlock)();

/**
 执行错误;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
        ---CODE-----
 });
 */
@property(nonatomic, copy) void(^exportErrorBlock)();


//----------------------------一下是内部使用-----------------------------------------------
-(int)getAssetType;
-(id)getSlice1;

@end

NS_ASSUME_NONNULL_END


/**
 //代码举例.
 
 NSString *jsonPath= [[NSBundle mainBundle] pathForResource:@"oneP" ofType:@"json"];
    aeView1=[LSOAeView parseJsonWithPath:jsonPath];
    
    NSURL *img0Url=[LSOFileUtil URLForResource:@"iphone180du" withExtension:@"MOV"];
    LSOAEVideoAsset *videoAsset=[[LSOAEVideoAsset alloc] initWithURL:img0Url];
    if([videoAsset prepare]){
        
        //错误回调
        [videoAsset setExportErrorBlock:^{
            
        }];
        
        //进度回调
        [videoAsset setExportProgressBlock:^(CGFloat progress, CGFloat percent) {
            LSOLOG(@"---progress is :%f percent is :%f",progress,percent)
        }];
        
        //完成回调
        [videoAsset setExportCompletionBlock:^{
 
 
 
            dispatch_async(dispatch_get_main_queue(), ^{
 
 
                //在完成之后, 把videoAsset输入到 aeView 中.
                [aeView1 updateVideoImageWithKey:@"image_0" AeVideoAsset:videoAsset];
                drawpadSize=CGSizeMake(aeView1.jsonWidth, aeView1.jsonHeight);
                aeCompositionView=[DemoUtils createAeCompositionView:self.view.frame.size drawpadSize:drawpadSize];
                [self.view addSubview:aeCompositionView];
                [self startAEComposition];
                
            });
 
 
 
        }];
        //开始执行
        [videoAsset startCompress];
    }
 }
 */
