//
//  LanSongUtils.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "LanSongUtils.h"
#import <LanSongEditorFramework/LanSongEditor.h>

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "VideoPlayViewController.h"

@implementation LanSongUtils



+(void) showHUDToast:(NSString *)strHint
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.mode=MBProgressHUDModeDeterminate;
    HUD.labelText=strHint;
    [HUD hide:YES afterDelay:1];
}

+(void)startVideoPlayerVC:(UINavigationController*)nav dstPath:(NSString *)dstPath
{
    if ([SDKFileUtil fileExist:dstPath]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstPath;
        [nav pushViewController:videoVC animated:YES];
    }else{
        NSString *str=[NSString stringWithFormat:@"文件不存在:%@",dstPath];
        [LanSongUtils showHUDToast:str];
    }
}

@end
