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
    srcVideoPath=[AppDelegate getInstance].currentEditVideo;
    
    scrollView.delegate=self;
    [scrollView configureView:@[
                                @"1.背景音乐/裁剪/缩放/压缩/logo等10个功能>>",
                                @"2.加减速",
                                @"3.旋转90度",
                                @"4.删除logo",
                                @"5.调整帧率",
                                @"6.倒序",
                                @"7.镜像",
                                @"8.多个视频画面拼接",
                                @"9.多个视频时长拼接",
                                @"10.单张图片变视频",
                                @"11.多张图片变视频",
                                @"12.视频转Gif(暂无)"] width:self.view.frame.size.width];
}

- (void)LSOFullWidthButtonsViewSelected:(int)index
{
    if(index==0){
        UIViewController *pushVC=[[CommonEditVC alloc] init];
        [self.navigationController pushViewController:pushVC animated:YES];
    }else {
        switch (index) {
            case 1:
                [self testAdjustSpeed];
                break;
            case 4:
                [self testAdjustFrameRate];
                break;
            case 5:
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
    LSOVideoEditor *ffmpeg=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [ffmpeg setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LSDELETE(@"percent  is :%d",percent)
            [weakSelf showProgress:percent];
        });
    }];
    
    [ffmpeg setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
            [hud hide];
        });
    }];
    [ffmpeg startAdjustVideoSpeed:srcVideoPath speed:0.5f];  //这里用速度放慢一倍来演示;
}
-(void)testAdjustFrameRate
{
    LSOVideoEditor *ffmpeg=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [ffmpeg setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [ffmpeg setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
            [hud hide];
        });
    }];
    [ffmpeg startAdjustFrameRate:srcVideoPath frameRate:15];
}
/**
 倒序
 */
-(void)testReverseVideo
{
    LSOVideoEditor *ffmpeg=[[LSOVideoEditor alloc] init];
    WS(weakSelf)
    [ffmpeg setProgressBlock:^(int percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:percent];
        });
    }];
    
    [ffmpeg setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
            [hud hide];
        });
    }];
    [ffmpeg startAVReverse:srcVideoPath];
    
}
-(void)showProgress:(int)percnet
{
    [hud showProgress:[NSString stringWithFormat:@"进度:%d",percnet]];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end

