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
                                @"12.视频转Gif",
                                @"13.更多常见功能处理"] width:self.view.frame.size.width];
}

- (void)LSOFullWidthButtonsViewSelected:(int)index
{
    if(index==0){
        UIViewController *pushVC=[[CommonEditVC alloc] init];
        [self.navigationController pushViewController:pushVC animated:YES];
    }else {
        [LanSongUtils showDialog:@"暂时没有写演示,功能在LSOVideEditor类中."];
    }
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
