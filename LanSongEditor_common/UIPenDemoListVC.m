//
//  UIPenDemoListVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/6/11.
//  Copyright © 2019 sno. All rights reserved.
//

#import "UIPenDemoListVC.h"
#include "DemoFullWidthButtonsView.h"
#import "UIPenDemoVC.h"


@interface UIPenDemoListVC () <LSOFullWidthButtonsViewDelegate>

@end

@implementation UIPenDemoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    DemoFullWidthButtonsView *scrollView=[DemoFullWidthButtonsView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];


    scrollView.delegate=self;
    [scrollView configureView:@[
                                @"0.UI图层演示--录制模式",
                                @"1.UI图层演示--导出模式"] width:self.view.frame.size.width];
}
- (void)LSOFullWidthButtonsViewSelected:(int)index
{
     UIPenDemoVC *pushVC=[[UIPenDemoVC alloc] init];
    if(index==0){
        pushVC.isRecordDrawPadMode=YES;
    }else{
        pushVC.isRecordDrawPadMode=NO;
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
