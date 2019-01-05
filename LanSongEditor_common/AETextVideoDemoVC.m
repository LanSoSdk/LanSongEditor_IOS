//
//  AETextVideoDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/21.
//  Copyright © 2018 sno. All rights reserved.

#import "AETextVideoDemoVC.h"

@interface AETextVideoDemoVC ()
{
    DrawPadAeText *aeTextPreview;
    
    LanSongView2 *lansongView;
    CGSize drawpadSize;
    
    LSOProgressHUD *hud;
    UILabel *labHint;
}
@end

@implementation AETextVideoDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self addRightBtn];
    
    
    hud=[[LSOProgressHUD alloc] init];
    
    aeTextPreview=[[DrawPadAeText alloc] init];
    drawpadSize=aeTextPreview.drawpadSize;
    
    CGSize size=self.view.frame.size;
    
    lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
    [self.view addSubview:lansongView];  //显示窗口增加到ui上;
    
    
    [aeTextPreview addLanSongView2:lansongView];
    
    __weak typeof(self) weakSelf = self;
    [aeTextPreview setFrameProgressBlock:^(BOOL isExport,float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf aeProgress:isExport percent:percent];
        });
    }];
    
    [aeTextPreview setCompletionBlock:^(BOOL isExport,NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isExport){
                [weakSelf drawpadCompleted:path];
            }
        });
    }];
    [self initUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startAEPreview];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAePreview];
}
-(void)startAEPreview
{
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"textAudio" withExtension:@"m4a"];
    [aeTextPreview addAudioPath:sampleURL];
    
    /*
     这两行文字和对应的开始时间, 结束时间都是从 语音后的结果, 你可以是一段文字, 或多段文字.
     如果是一长段文字, 我们内部会分割, 如果是很短的, 则独自一行.
     */
    NSString *allText=@"从一开始的一无所有，到人生的第一个30万真的很不容易，到后来慢慢发展到120万500万800万，甚至1200万，我已经对这些数字麻木了.";
    [aeTextPreview pushText:allText startTime:170.0/1000.0 endTime:12885.0/1000.0];
    
    NSString *allText2=@"不管手机像素的高低，为什么就拍不出我这该死又无处安放的魅力呢？";
    [aeTextPreview pushText:allText2 startTime:13260.0/1000.0 endTime:19495.0/1000.0];
    
    
    [aeTextPreview startPreview];
}


-(void)stopAePreview
{
    if (aeTextPreview!=nil) {
        [aeTextPreview cancel];
    }
}
-(void)aeProgress:(BOOL)isExport percent:(float) percent
{
    //     LSTODO(@"percent  :%f",percent);
    if(isExport){  //LSTODO这里应该是百分比
        [hud showProgress:[NSString stringWithFormat:@"进度:%d",(int)(percent*100)]];
    }
}

-(void)drawpadCompleted:(NSString *)path
{
    [hud hide];
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}

- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn {
    NSLog(@" addRightBtn  onClickedOKbtn");
    [aeTextPreview startExport];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUI
{
    UILabel *lab=[[UILabel alloc] init];
    [lab setTextColor:[UIColor redColor]];
    [self.view  addSubview:lab];
    
    lab.text=@"一键导出操作,里面的各种文字处理代码和原Ae动画开源!";
    lab.numberOfLines=3;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}
-(void)dealloc
{
    [self stopAePreview];
}
@end

