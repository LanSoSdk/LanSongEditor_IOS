//
//  TESTAEPreview.m
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "TESTAEPreview.h"
#import "LSTODOImageUtil.h"
#import "VideoPlayViewController.h"
#import "AEPreviewVC2.h"

@interface TESTAEPreview()
{
    UIView  *container;
    
    DrawPadAEPreview *aePreview;
    
    LanSongView2 *lansongView;
    BitmapPen *bmpPen;
    CGSize drawpadSize;
    VideoPen *videoPen;
}
@end
@implementation TESTAEPreview
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"AE演示";

    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];

    [self initView];

}

/**
 点击后, 进去界面.
 */
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    pushVC=[[AEPreviewVC2 alloc] init];
//    switch (sender.tag) {
//        case 601:
//            {
//                break;
//            }
//        case 605:
//            break;
//        default:
//            break;
//    }
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
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
    
    UIView *view=[self newButton:container index:601 hint:@"奥巴马预览"];
    view=[self newButton:view index:602 hint:@"奥巴马预览_编码"];
    view=[self newButton:view index:603 hint:@"奥巴马_后台"];
    view=[self newButton:view index:604 hint:@"早安_预览"];
    view=[self newButton:view index:605 hint:@"早安_编码"];
    view=[self newButton:view index:606 hint:@"早安_后台"];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).with.offset(40);
    }];
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
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
@end
