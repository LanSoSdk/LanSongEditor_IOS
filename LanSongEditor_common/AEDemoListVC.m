//
//  AePreviewDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "AEDemoListVC.h"
#include "DemoFullWidthButtonsView.h"
#import "AEModuleDemoVC.h"
#import "AEPreviewDemoVC.h"
#import "AECompositionDemoVC.h"

@interface AEDemoListVC () <LSOFullWidthButtonsViewDelegate>
{
    UIView *container;
}
@end

@implementation AEDemoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    DemoFullWidthButtonsView *scrollView=[DemoFullWidthButtonsView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    scrollView.delegate=self;
    [scrollView  configureView:@[@"紫霞仙子",@"早安(替换视频)",@"小黄鸭",@"多个图片合成",@"图片替换视频演示",@"卡点 模板"] width:self.view.frame.size.width];
}
- (void)LSOFullWidthButtonsViewSelected:(int)index
{
//    AECompositionDemoVC *pushVC=[[AECompositionDemoVC alloc] init];
    //老版本
    AEPreviewDemoVC  *pushVC=[[AEPreviewDemoVC alloc] init];
    switch (index) {
        case 0:
            pushVC.AeType=kAEDEMO_XIANZI;
            break;
        case 1:
            pushVC.AeType=kAEDEMO_ZAO_AN;
            break;
        case 2:
            pushVC.AeType=kEDEMO_XIAOHUANGYA;
            break;
        case 3:
            pushVC.AeType=kEDEMO_MORE_PICTURE;
            break;
        case 4:
            pushVC.AeType=kEDEMO_REPLACE_VIDEO;
            break;
        case 5:
            pushVC.AeType=kEDEMO_KADIAN;
            break;
        case 6:
            pushVC.AeType=kEDEMO_GAUSSIAN_BLUR;
            break;
        default:
            [DemoUtils showDialog:@"暂时没有这个举例(nothing)"];
            return;
    }
    [self.navigationController pushViewController:pushVC animated:NO];
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
