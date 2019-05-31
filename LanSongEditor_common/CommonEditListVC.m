//
//  CommonEditListVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/3/12.
//  Copyright © 2019 sno. All rights reserved.
//

#import "CommonEditListVC.h"
#include "LSOFullWidthButtonsView.h"
#import "CommonEditVC.h"

@interface CommonEditListVC () <LSOFullWidthButtonsViewDelegate>
{
     UIView *container;
    NSString *srcVideoPath;
    LSOProgressHUD *hud;
    LSOVideoEditor *videoEditor;
}
@end

@implementation CommonEditListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    LSOFullWidthButtonsView *scrollView=[LSOFullWidthButtonsView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
     hud=[[LSOProgressHUD alloc] init];
     srcVideoPath=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    
    scrollView.delegate=self;
    [scrollView configureView:@[
                                @"0.背景音乐/裁剪/缩放/压缩/logo等11个功能>>",
                                @"1.加减速",
                                @"2.删除logo",
                                @"3.调整帧率",
                                @"4.倒序",
                                @"5.多个视频画面拼接",
                                @"6.多个视频时长拼接",
                                @"7.多张图片变视频",
                                @"8.视频转Gif(暂无)"] width:self.view.frame.size.width];
}
- (void)viewDidAppear:(BOOL)animated
{
}
- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)LSOFullWidthButtonsViewSelected:(int)index
{
    if(index==0){
        UIViewController *pushVC=[[CommonEditVC alloc] init];
        [self.navigationController pushViewController:pushVC animated:NO];
    }else {
        switch (index) {
            case 1:
                [self testAdjustSpeed];
                break;
            case 2:
                [self testDelogo];
                break;
            case 3:
                [self testAdjustFrameRate];
                break;
            case 4:
                [self testReverseVideo];
                break;
            default:
                 [LanSongUtils showDialog:@"暂时没有写演示,功能在LSOVideEditor类中."];
                break;
        }
    }
}

/**
 调速,  这里把速度放慢一倍;
 */
-(void)testAdjustSpeed
{
    videoEditor=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [videoEditor setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [videoEditor setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf completedBlock:dstPath];
        });
    }];
    [videoEditor startAdjustVideoSpeed:srcVideoPath speed:0.5f];  //这里用速度放慢一倍来演示;
}
-(void)testAdjustFrameRate
{
    videoEditor=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [videoEditor setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [videoEditor setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf completedBlock:dstPath];
        });
    }];
    [videoEditor startAdjustFrameRate:srcVideoPath frameRate:20];
}
/**
 倒序
 */
-(void)testReverseVideo
{
    videoEditor=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [videoEditor setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [videoEditor setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf completedBlock:dstPath];
        });
    }];
    [videoEditor startAVReverse:srcVideoPath isReverseAudio:YES];
}

-(void)testDelogo
{
    videoEditor=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [videoEditor setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [videoEditor setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf completedBlock:dstPath];
        });
    }];
    [videoEditor startDeleteLogo:srcVideoPath startX:0 startY:0 width:200 height:200];
}

//------------一下是完成+进度回调;
-(void)completedBlock:(NSString *)dst
{
      [hud hide];
    [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dst];
}
-(void)showProgress:(int)percnet
{
    [hud showProgress:[NSString stringWithFormat:@"进度:%d",percnet]];
}
@end
