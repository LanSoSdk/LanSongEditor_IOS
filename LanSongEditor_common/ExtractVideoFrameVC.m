//
//  ExtractVideoFrameVC.m
//  LanSongEditor_all
//
//  Created by sno on 16/10/2017.
//  Copyright © 2017 sno. All rights reserved.
//

#import "ExtractVideoFrameVC.h"
#import "LanSongUtils.h"

//测试快速读取视频帧.
@interface ExtractVideoFrameVC ()
{
    UILabel *labProgresse;
    NSURL *videoURL;
    ExtractVideoFrame *extractFrame;
    int  frameCnt;
    CFAbsoluteTime startTime; //记录开始时间.
}
@end

@implementation ExtractVideoFrameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self initUI];
    frameCnt=0;
}


-(void)startExecute
{
    videoURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    extractFrame=[[ExtractVideoFrame alloc] initWithPath:[SDKFileUtil urlToFileString:videoURL]];
    if(extractFrame!=nil)
    {
        __weak typeof(self) weakSelf = self;
        [extractFrame setExtractProcessBlock:^(UIImage *img, CMTime frameTime) {
            if(img==nil){
                NSLog(@"ERROR :  img is nil");
            }else{
                /*
                 拿到视频帧后,建议放到一个链表或cache中, 在另一线程中处理显示等, 以免导致线程堵塞.
                 */
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showProgress:CMTimeGetSeconds(frameTime)];
                });
                
//                if(frameCnt>=50){  //或者你可以随时停止,这里举例检测50帧后停止,这样就只取了50帧.
                    //                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [extractFrame stop];
                    //                });
                    //            }
            }
        }];
        
        [extractFrame setExtractCompletedBlock:^(ExtractVideoFrame *v){
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf showComplete];
             });
        }];
        startTime= CFAbsoluteTimeGetCurrent();
        frameCnt=0;
        [extractFrame start];  //内部会开启一个线程去提取.
        //[extractFrame startWithSeek:CMTimeMake(2, 1)];  //您可以指定开始时间, 比如从2秒开始;
    }
}

/**
 显示进度和帧数.
 */
-(void) showProgress:(CGFloat) sampleTime
{
    NSString *hint=[NSString stringWithFormat:@"当前进度是:%f",sampleTime];
    labProgresse.text=hint;
    frameCnt++;
}

/**
 结束
 */
-(void)showComplete
{
     NSString *str= [NSString stringWithFormat:@"处理完毕!\n 提取总帧数是:%d\n 消耗的时间是: %0.3f(秒)",frameCnt, (CFAbsoluteTimeGetCurrent() - startTime)];
    NSLog(@"%@",str);
    
    labProgresse.text=str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
            
        case 100 :
            [self startExecute];
            break;
    }
}
-(void)initUI
{
    UILabel *label=[UILabel new];
    label.text=@"演示:\n 快速得到视频中的所有帧\n \n 您可以指定开始时间/结束时间";
    label.numberOfLines=0;
    label.textColor=[UIColor redColor];
    
    
    
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=100;
    [btn setTitle:@"开始执行" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    labProgresse=[[UILabel alloc] init];
    labProgresse.text=@"";
    labProgresse.numberOfLines=0;
    
    [self.view addSubview:label];
    [self.view addSubview:btn];
    [self.view addSubview:labProgresse];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(padding*5);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 150));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    [labProgresse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(btn.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 150));
    }];
}
-(void)dealloc
{
}
@end


