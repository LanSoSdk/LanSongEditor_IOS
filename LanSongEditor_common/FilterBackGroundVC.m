//
//  FilterBackGroundViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "FilterBackGroundVC.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import <LanSongEditorFramework/LanSongEditor.h>

@interface FilterBackGroundVC ()
{
    UILabel *labProgresse;
    UIButton *btnPlay;
    DrawPadExecute *drawPad; //后台录制的画板.
}
@end

@implementation FilterBackGroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      self.view.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btn=[[UIButton alloc] init];
      btn.tag=100;
    [btn setTitle:@"开始执行" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    labProgresse=[[UILabel alloc] init];
    labProgresse.text=@"";

    
    btnPlay=[[UIButton alloc] init];
    btnPlay.tag=101;
    [btnPlay setTitle:@"结果预览" forState:UIControlStateNormal];
    [btnPlay setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnPlay.backgroundColor=[UIColor whiteColor];
    
    [btnPlay addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn];
    [self.view addSubview:btnPlay];
    [self.view addSubview:labProgresse];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    [labProgresse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(btn.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 60));
    }];
    
    [btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labProgresse.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(labProgresse.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    btnPlay.enabled=NO;
    
    
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
            
        case 100 :
            [self startExecute];
            break;
        case  101:
            
            break;
        default:
            break;
    }
}
-(void) showProgress:(CGFloat) sampleTime
{
    NSString *hint=[NSString stringWithFormat:@"当前进度是:%f",sampleTime];
    labProgresse.text=hint;
}
-(void)showComplete
{
    labProgresse.text=@"处理完毕";
    btnPlay.enabled=YES;
}
-(void)startExecute
{
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    
    
    NSString *pathToMovie = [SDKFileUtil genTmpMp4Path];
    
    
    
    drawPad =[[DrawPadExecute alloc] initWithPath:[SDKFileUtil urlToFileString:sampleURL] dstPath:pathToMovie];
    
    GPUImageFilter *filter= (GPUImageFilter *)[[GPUImageSepiaFilter alloc] init];
    
    [drawPad switchFilterTo:filter];
    //设置进度
    __weak typeof(self) weakSelf = self;
    [drawPad setOnProgressBlock:^(CGFloat sampleTime) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前的进度是:%f",sampleTime);
            [weakSelf showProgress:sampleTime];
            // weakSelf.progressLabel.text = [NSString stringWithFormat:@"%f",sampleTime];  //后面更改为weak版本的self
        });
    }];
    
    //设置完成后的回调
    [drawPad setOnCompletionBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            weakSelf.progressLabel.text=@"完成";  //后面更改为weak版本的self
            NSLog(@"处理完成");
            [weakSelf showComplete];
        });
    }];
    
    [drawPad startDrawPad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
