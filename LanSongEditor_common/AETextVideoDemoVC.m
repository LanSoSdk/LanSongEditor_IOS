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
    
    DemoProgressHUD *hud;
    UILabel *labHint;
    NSString *jsonPath;
    
    UIView *rootJsonView;
    UIImageView *commonTextImageView;
    CALayer *_wrapperLayer;
}
@end

@implementation AETextVideoDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self addRightBtn];
    
    hud=[[DemoProgressHUD alloc] init];
    
    CGSize size=self.view.frame.size;
    lansongView=[DemoUtils createLanSongView:size drawpadSize:CGSizeMake(540, 960)];
    [self.view addSubview:lansongView];  //显示窗口增加到ui上;
    [self initUI];
    jsonPath= [[NSBundle mainBundle] pathForResource:@"textONLY3" ofType:@"json"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startAEPreview];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAePreview];
}
-(void)createAePreview
{
    if (aeTextPreview!=nil) {
        [aeTextPreview cancel];
        aeTextPreview=nil;
    }
   
    aeTextPreview=[[DrawPadAeText alloc] initWithJsonPath:jsonPath];
    [aeTextPreview addLanSongView2:lansongView];  //增加显示界面;
    [self loadTextAudio];  //加载声音
    
    rootJsonView=[[UIView alloc] initWithFrame:aeTextPreview.aeView.frame];
    
    
    __weak typeof(self) weakSelf = self;
    [aeTextPreview setFrameProgressBlock:^(BOOL isExport,CGFloat progress, float percent) {
       // dispatch_async(dispatch_get_main_queue(), ^{
       
        
            [weakSelf aeProgress:isExport  progress:progress percent:percent];
       // });
    }];
    
    [aeTextPreview setCompletionBlock:^(BOOL isExport,NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isExport){
                [weakSelf drawpadCompleted:path];
            }else{
                [weakSelf startAEPreview];
            }
        });
    }];
    
//    [aeTextPreview addBackgroundImage:[UIImage imageNamed:@"pic5"]];
}
-(void)startAEPreview
{
    if (aeTextPreview==nil) {
        [self createAePreview];
    }
    
    [aeTextPreview startPreview];
    [aeTextPreview getPreviewVideoPen].avplayer.rate=0.5f;
}

/**
 加载文字声音
 */
-(void)loadTextAudio
{
   // [DrawPadAeText showDebugInfo:YES];
    
    //增加原声音
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"recognitionAudio1" withExtension:@"m4a"];
    [aeTextPreview setAudioPath:sampleURL volume:1.0f];

    //测试视频
//    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"iphone_front_180du" withExtension:@"mov"];
//    [aeTextPreview setBgVideoPath:sampleURL volume:1.0f];
    
    //测试增加背景音乐
//    NSURL *audioURL2 = [[NSBundle mainBundle] URLForResource:@"hongdou10s" withExtension:@"mp3"];
//    [aeTextPreview  addBackgroundAudio:audioURL2 volume:0.8f loop:YES];
    
    NSString *allText=@"从一开始的一无所有到人生的第一个30万真的很不容易到后来慢慢发展到120万500万800万甚至1200万我已经对这些数字麻木了";
    [aeTextPreview pushText:allText startTime:170.0/1000.0 endTime:12885.0/1000.0];  //时间暂时不用.
    NSString *allText2=@"不管手机像素的高低为什么就拍不出我这该死又无处安放的魅力呢？";
    [aeTextPreview pushText:allText2 startTime:13260.0/1000.0 endTime:19495.0/1000.0];
    
    //打印所有的文字
//    for (LSOOneLineText *oneLine in aeTextPreview.oneLineTextArray) {
//        NSLog(@"当前行是:%d,imageId:%@, 文字:--->%@<----开始时间:%f,startFrame:%d",oneLine.lineIndex,oneLine.jsonImageID,oneLine.text,oneLine.startTimeS,oneLine.startFrame);
//    }
//    [self replaceText];
}
//测试替换文字
-(void)replaceText
{
    if(aeTextPreview.oneLineTextArray.count>5){
        LSOOneLineText *oneText=[aeTextPreview.oneLineTextArray objectAtIndex:5];
        oneText.text=[NSString stringWithFormat:@"测试测试替换"];  //同样你可以修改字体, 文字颜色, 字号, 甚至自己设计文字图片.
        [aeTextPreview updateTextArrayWithConvert:NO];
    }
}
-(void)stopAePreview
{
    if (aeTextPreview!=nil) {
        [aeTextPreview cancel];
    }
}
-(void)aeProgress:(BOOL)isExport progress:(CGFloat)progress percent:(float) percent
{
    //如果你另外增加了一个UI,则UI可以随进度变动;(测试用)
//    NSString *str=[NSString stringWithFormat:@"这是切换的第%d张图片",lsCnt];
//    UIImage *image=[self createImageWithText:str imageSize:CGSizeMake(400, 76) txtColor:[UIColor redColor] fontSize:25];
//    commonTextImageView.image=image;

    if(isExport){
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
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportVideo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)exportVideo {
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
    
    lab.text=@"一键导出操作!";
    lab.numberOfLines=3;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    UIButton *btnClose=[[UIButton alloc] init];
    
    [btnClose setTitle:@"切换文字动画" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font=[UIFont systemFontOfSize:20];
    btnClose.tag=301;
    [btnClose addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(180, 60));
    }];
}
-(void)doButtonClicked:(UIView *)sender
{
    if (aeTextPreview!=nil) {
        [aeTextPreview cancel];
        aeTextPreview=nil;
    }
    jsonPath= [[NSBundle mainBundle] pathForResource:@"textVideo2" ofType:@"json"];
    [self startAEPreview];
}
-(void)dealloc
{
    [self stopAePreview];
}

-(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size txtColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;
{
    //文字转图片;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode=NSLineBreakByTruncatingTail;
    
    //获取高度.
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : textColor,
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : style, };
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage *)createImageWithSize:(CGSize)size
{
    //文字转图片;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode=NSLineBreakByTruncatingTail;
    
    //获取高度.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
@end
