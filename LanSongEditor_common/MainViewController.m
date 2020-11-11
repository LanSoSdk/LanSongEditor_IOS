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
    

    //app store demo: https://apps.apple.com/cn/app/%E8%93%9D%E6%9D%BE%E8%A7%86%E9%A2%91%E7%BC%96%E8%BE%91%E4%BD%93%E9%AA%8C/id1512903172
       
       UIImageView *imageView=[[UIImageView alloc] init];
       UIImage *image=[UIImage imageNamed:@"demoLink"];
       imageView.image=image;
       
       [container addSubview:imageView];
       
       CGSize size=self.view.frame.size;
       CGFloat padding=size.height*0.04;
       
       
       [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(view.mas_bottom).with.offset(padding);
           make.left.mas_equalTo(container.mas_left).with.offset(10);
           make.size.mas_equalTo(CGSizeMake(200, 200));
       }];
    

}
-(UIView *)newLanSongTech:(UIView *)topView
{
    
    labPath=[[UILabel alloc] init];
    NSString *text1=[NSString stringWithFormat:
                     @" The simplest demo\n current version:%@, \n Expire date::%d  %d   \n\n full demo App Store link:",[LanSongEditor getVersion],
                        [LanSongEditor getLimitedYear],[LanSongEditor getLimitedMonth]];
    
    
    //https://apps.apple.com/cn/app/%E8%93%9D%E6%9D%BE%E8%A7%86%E9%A2%91%E7%BC%96%E8%BE%91%E4%BD%93%E9%AA%8C/id1512903172
    
    
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

