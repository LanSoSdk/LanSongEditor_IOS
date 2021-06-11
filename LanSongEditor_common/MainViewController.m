//
//  MainViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "DemoUtils.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "AEModuleDemoVC.h"
#import "AEPreviewDemoVC.h"

#import "UIView+UIImage.h"
#import "AEDemoListVC.h"
#import "VideoEditorDemoVC.h"




@interface MainViewController ()
{
    UIView  *container;
    UILabel *labPath; // 视频路径.
}
@end



@implementation MainViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝松短视频SDK";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    /*
     初始化SDK
     */
    if([LanSongEditor initSDK:nil]==NO){
        [DemoUtils showDialog:@"SDK已经过期(time out),请联系我们:"];
    }
    //初始化SDK.
    [LanSongFFmpeg initLanSongFFmpeg];
    /*
     删除sdk中所有的临时文件.
     */
    [LSOFileUtil deleteAllSDKFiles];
    [self initView];
    
    [DemoUtils showDialog:@"这是最简单的演示, 完整功能, 请联系我们."];
}
- (void)viewDidAppear:(BOOL)animated
{
    [DemoUtils setViewControllerPortrait];
}
/**
 点击后, 进去界面.
 */
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    switch (sender.tag) {
        case 101:
            pushVC=[[VideoEditorDemoVC alloc] init];
            break;
            
        case 102:
            pushVC=[[AEDemoListVC alloc] init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:pushVC animated:NO];
}

-(void)initView
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *view=[self newLanSongTech:container];
    
    view=[self newButton:view index:101 hint:@"Video Edit"];
    
    view=[self newButton:view index:102 hint:@"AE Template"];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).with.offset(40);
    }];
}
-(UIView *)newLanSongTech:(UIView *)topView
{
    labPath=[[UILabel alloc] init];
    NSString *text1=[NSString stringWithFormat:
                     @" The simplest demo\n current version:%@, \n Expire date::%d  %d   \n\n full demo App Store link:",[LanSongEditor getVersion],
                        [LanSongEditor getLimitedYear],[LanSongEditor getLimitedMonth]];
    
    labPath.text=text1;
    labPath.textColor=[UIColor whiteColor];
    labPath.numberOfLines=10;
    
    
    [container addSubview:labPath];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    
    [labPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(padding);
        make.left.mas_equalTo(container.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width-10, 220));  //按钮的高度.
    }];
    
    return labPath;
}



-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));
        }];
    }
    return btn;
}


-(void)btnDown:(UIView *)sender
{
    sender.backgroundColor=[UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}


//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end

