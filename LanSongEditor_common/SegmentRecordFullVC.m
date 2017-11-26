//
//  ViewController.m
//  iosTest1
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SegmentRecordFullVC.h"

@interface SegmentRecordFullVC ()
{
    SegmentRecordFullView *fullView;
}
    //@property (nonatomic, strong) UIButton *btn;
    //@property (nonatomic, strong) UILabel *label;
@end

@implementation SegmentRecordFullVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = [[UIScreen mainScreen] bounds];
     fullView= [[SegmentRecordFullView alloc] initWithFrame:frame];
    [self.view addSubview:fullView];
    
    [fullView setNav:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [fullView stopCameraCapture];
    NSLog(@"SegmentRecordFullVC  dealloc....");
    
}
@end
