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
#import "FilterBackGroundVC.h"
#import "DrawPadRealTimeVC.h"
#import "CommDemoListTableVC.h"



@interface MainViewController ()
{
    UIView  *container;
    UIButton *btnForeGround;
    UIButton *btnBackGround;
    
    UIButton *fgUIPen;
    UIButton *bgUIPen;
    UIButton *commonFunction;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝松视频编辑--功能列表";
    
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
    
    UILabel *notUse=[[UILabel alloc] init];
    //自动折行设置
    notUse.lineBreakMode = UILineBreakModeWordWrap;
    notUse.numberOfLines=0;
    notUse.text=@"1.1.0,增加了画板和视频画笔. 当前版本在逐渐完善中, 感谢您的关注.\n 欢迎联系我们: QQ:1852600324; email:support@lansongtech.com";
    notUse.textColor=[UIColor whiteColor];
    notUse.backgroundColor=[UIColor redColor];
    
    
    btnForeGround=[self newButton:0 hint:@"前台滤镜[画板 主演示]"];
    
    btnBackGround=[self newButton:1 hint:@"后台滤镜(old)"];
    
    fgUIPen=[self newButton:2 hint:@"前台[UI画笔]"];
    bgUIPen=[self newButton:3 hint:@"后台[UI画笔](old)"];
    commonFunction=[self newButton:4 hint:@"视频编辑基本功能>>>"];
    
    
    [container addSubview:btnForeGround];
    [container addSubview:btnBackGround];
    [container addSubview:fgUIPen];
    [container addSubview:bgUIPen];
    [container addSubview:commonFunction];
    [container addSubview:notUse];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    [btnForeGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 60));
    }];
    
    [btnBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnForeGround.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    [fgUIPen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnBackGround.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    [bgUIPen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fgUIPen.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    [commonFunction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgUIPen.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 60));
    }];
    
    [notUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commonFunction.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 150));
    }];
    
    
    //因为是UIScollView, 这个一定要增加.
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(notUse.mas_bottom).with.offset(40);
    }];
    
//    [self showVersionDialog];
}


-(UIButton *)newButton:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doButtonClicked:(UIView *)sender
{
    UIViewController *pushVC=nil;
    switch (sender.tag) {
        case 0:
            pushVC=[[DrawPadRealTimeVC alloc] initWithNibName:@"DrawPadRealTimeVC" bundle:nil];
            ((DrawPadRealTimeVC *)pushVC).isAddUIPen=NO;
            break;
        case 1:
            pushVC=[[FilterBackGroundVC alloc] init];
            ((FilterBackGroundVC *)pushVC).isAddUIPen=NO;
            break;
         case 2:
            pushVC=[[DrawPadRealTimeVC alloc] initWithNibName:@"DrawPadRealTimeVC" bundle:nil];
            ((DrawPadRealTimeVC *)pushVC).isAddUIPen=YES;
            break;
        case 3:
            pushVC=[[FilterBackGroundVC alloc] init];
            ((FilterBackGroundVC *)pushVC).isAddUIPen=YES;
            break;
        case 4:
            pushVC=[[CommDemoListTableVC alloc] init];
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
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
