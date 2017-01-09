//
//  MainViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "FilterRealTimeDemoVC.h"

#import "FilterBackGroundVC.h"
#import "CommDemoListTableVC.h"
#import "PictureSetsRealTimeVC.h"
#import "VideoPictureRealTimeVC.h"
#import "ViewPenRealTimeDemoVC.h"
#import "TestDemoVC.h"
#import "CameraPenDemoVC.h"



@interface MainViewController ()
{
    UIView  *container;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"[画板画笔]---开发架构举例";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    

    
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
    
    UILabel *versionHint=[[UILabel alloc] init];
    //自动折行设置
  //  notUse.lineBreakMode = UILineBreakModeWordWrap;
    versionHint.numberOfLines=0;
    versionHint.text=@"1.4.0,当前已有的画笔有: 视频画笔, 图片画笔, UI画笔,摄像头画笔,欢迎您的使用.\n 欢迎联系我们: QQ:1852600324; email:support@lansongtech.com";
    versionHint.textColor=[UIColor whiteColor];
    versionHint.backgroundColor=[UIColor redColor];
    
    
    
    UIView *view=[self newButton:container index:0 hint:@"前台滤镜"];
    view=[self newButton:view index:1 hint:@"后台滤镜"];
    view=[self newButton:view index:2 hint:@"视频和图片叠加"];
    view=[self newButton:view index:3 hint:@"视频和UI叠加"];
    view=[self newButton:view index:4 hint:@"图片影集"];
    
    view=[self newButton:view index:5 hint:@"摄像头画笔"];
    
    view=[self newButton:view index:6 hint:@"视频基本编辑>>>"];
  
    
    [container addSubview:versionHint];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    
    [versionHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 150));
    }];
        //
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(versionHint.mas_bottom).with.offset(40);
    }];
    
//    [self showVersionDialog];
}
-(void)doButtonClicked:(UIView *)sender
{
    
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    switch (sender.tag) {
        case 0:
            pushVC=[[FilterRealTimeDemoVC alloc] init];  //滤镜
          //  pushVC =[[TestDemoVC alloc] init];
            break;
        case 1:
            pushVC=[[FilterBackGroundVC alloc] init];  //后台滤镜
            ((FilterBackGroundVC *)pushVC).isAddUIPen=NO;
            break;
        case 2:
            pushVC=[[VideoPictureRealTimeVC alloc] init];  //视频画笔和图片画笔
            break;
        case 3:
            pushVC=[[ViewPenRealTimeDemoVC alloc] init];  //视频+UI画笔.
            break;
        case 4:
            pushVC=[[PictureSetsRealTimeVC alloc] init]; //图片画笔
            break;
        case 5:
            pushVC=[[CameraPenDemoVC alloc] init]; //摄像头画笔演示
            break;
        case 6:
            pushVC=[[CommDemoListTableVC alloc] init];  //普通功能演示
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 40));
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 40));
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


-(void)showVersionDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"欢迎您评估我们的sdk,当前版本是:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
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
