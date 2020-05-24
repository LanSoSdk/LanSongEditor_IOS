//
//  TESTShanChu.m
//  LanSongEditor_all
//
//  Created by sno on 2019/12/31.
//  Copyright © 2019 sno. All rights reserved.
//

#import "TESTShanChu.h"

#import "DemoProgressHUD.h"



/**
 暂时不要使用. 遇到问题;
 */
@interface TESTShanChu ()
{
    LSOAeCompositionView *aeCompositionView;
    
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    
    UILabel *labProgress;
    UIView *view;
    
    //-------Ae中的素材
    
    NSURL *bgVideoURL;
    
    NSURL *mvColorURL;
    NSURL *mvMaskURL;
    
    NSString *json1Path;
    NSString *json2Path;
    NSURL *addAudioURL;
    
    NSString *moduleName;
    
    UISwitch *uiswitch;
    
    
    LSOAeView  *aeView1;
    LSOAeView *aeView2;
}
@property  DemoProgressHUD *hud;
@property CIContext *ciContext;
@end

@implementation TESTShanChu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    bgVideoURL=nil;
    json1Path=nil;
    mvMaskURL=nil;
    mvColorURL=nil;
    
    _hud=[[DemoProgressHUD alloc] init];
    
    
    //第一步:准备各种素材;
    [self prepareAeAsset];
    
    
    //解析导出的json文件, 并得到aeView对象;
    aeView1=[LSOAeView parseJsonWithPath:json1Path];
    
    
    //第二步:给json对象替换各种素材;
    [self replaceAeAsset:aeView1];
    
    [self initView];
    
    //开始预览
    [self startAEComposition];
}

-(void)initView
{
    
    drawpadSize=CGSizeMake(aeView1.jsonWidth, aeView1.jsonHeight);
    if(aeCompositionView!=nil){
        [aeCompositionView removeFromSuperview];
        aeCompositionView=nil;
        
        [labProgress removeFromSuperview];
        [view removeFromSuperview];
    }
    aeCompositionView=[DemoUtils createAeCompositionView:self.view.frame.size drawpadSize:drawpadSize];
    [self.view addSubview:aeCompositionView];
    
        UIView *view=[self createButtons:aeCompositionView];
        view=[self newButton:view index:202 hint:@"后台处理(导出)"];
        [self createUISwitch:view];
        
        //显示进度;
        labProgress=[[UILabel alloc] init];
        labProgress.textColor=[UIColor redColor];
        [self.view addSubview:labProgress];
        
        CGSize size=self.view.frame.size;
        [labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_bottom);
            make.left.mas_equalTo(view.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 40));
        }];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_hud hide];
    [self stopAePreview];
}
/**
 准备各种素材
 */
-(void)prepareAeAsset
{
    bgVideoURL=nil;
    
    moduleName=@"replaceVideo";
    
    
    json1Path=[[NSBundle mainBundle] pathForResource:moduleName ofType:@"json"];
    mvColorURL=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_mvColor",moduleName] withExtension:@"mp4"];
}


/**
 开始Ae合成
 */
-(void)startAEComposition
{
    if(aeCompositionView.isRunning){
        NSLog(@"正在运行. 返回");
        return;
    }
    
    //创建容器(容器是用来放置图层, 所有素材都是一层一层叠加起来处理)
    
    [aeCompositionView addFirstPenWithURL:bgVideoURL];
    
    //增加json图层;
    [aeCompositionView addSecondPen:aeView1];
    //增加MV图层;
    
    
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aeCompositionView addThirdPen:mvColorURL withMask:mvMaskURL];
    }
    
    UIImage *logo=[UIImage imageNamed:@"small"];
    [aeCompositionView addOtherBitmapPen:logo position:kLSOPenLeftTop];
    
    
    //设置循环播放;
    aeCompositionView.loopPlay=YES;
    
    //-----------------增加回调---------------------------------------------
    __weak typeof(self) weakSelf = self;
    //预览缓冲回调;
    [aeCompositionView setPreviewBufferingBlock:^(BOOL isBuffering) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isBuffering){
                [weakSelf.hud showProgress:@"(手机慢或模板复杂)加速渲染中..."];
            }else{
                [weakSelf.hud hide];
            }
        });
    }];
    
    //预览进度回调;
    [aeCompositionView setPreviewProgressBlock:^(CGFloat progress, CGFloat percent) {
        //  NSLog(@"------preview progress is :%f, %f",progress, percent);
    }];
    
    //导出进度回调;
    [aeCompositionView setExportProgressBlock:^(CGFloat progress, CGFloat percent) {
        // NSLog(@"----setExportProgressBlock is :%f, %f",progress, percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progress percent:percent];
        });
    }];
    
    //导出完成回调;
    [aeCompositionView setExportCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    
    
    //开始执行,
    [aeCompositionView startPreview];
    
    
}
/**
 替换AE中的素材
 */
-(void)replaceAeAsset:(LSOAeView *)aeView
{
    NSURL *videoUrl0=[LSOFileUtil URLForResource:@"dy_xialu2" withExtension:@"mp4"];
    NSURL *videoUrl1=[LSOFileUtil URLForResource:@"replaceVideo1" withExtension:@"mp4"];
    NSURL *videoUrl2=[LSOFileUtil URLForResource:@"replaceVideo2" withExtension:@"mp4"];
    
    //第一张图片替换为视频
    [aeView updateVideoImageWithKey:@"image_0" url:videoUrl1];
    
    //第二个视频
    LSOAEVideoSetting *setting=[[LSOAEVideoSetting alloc] init];
    setting.startTimeS=2;
    setting.endTimeS=8;
    [aeView updateVideoImageWithKey:@"image_1" url:videoUrl0 setting:setting];
    
    //第三个视频
    [aeView updateVideoImageWithKey:@"image_2" url: videoUrl2];
    self.ciContext = [CIContext contextWithOptions:nil];
    [aeView updateTextWithOldText:@"临时测试模板--蓝松SDK" newText:@"蓝松科技有限公司测试替换文字123abc..."];
    
}
/**
 停止预览
 */
-(void)stopAePreview
{
    if (aeCompositionView!=nil) {
        [aeCompositionView cancel];
    }
}
/**
 预览进度
 */
-(void)drawpadProgress:(CGFloat) progress percent:(CGFloat)percent
{
    [_hud showProgress:[NSString stringWithFormat:@"进度:%f",percent]];
}
/**
 预览完成
 */
-(void)drawpadCompleted:(NSString *)path
{
    [_hud hide];
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}
/**
 创建UI
 */
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
    }];
    
    return btn;
}
-(UIView *)createButtons:(UIView *)topView
{
    //点击按钮;
    UIButton *btnReplace=[self createButton:@"替换图片" tag:101];
    UIButton *btnPause=[self createButton:@"暂停预览" tag:102];
    UIButton *btnResume=[self createButton:@"恢复预览" tag:103];
    CGFloat btnWidth=self.view.frame.size.width/3 -15;
    CGFloat btnHeight=30;
    
    [btnReplace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [btnPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(btnReplace.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    
    [btnResume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(btnPause.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    return btnResume;
}

-(UIButton *)createButton:(NSString *)text tag:(int)tag
{
    UIButton *btn=[[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.tag=tag;
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

-(void)createUISwitch:(UIView *)topView
{
    UILabel *label=[[UILabel alloc] init];
    label.text=@"是否禁止缓冲";
    label.textColor=[UIColor blackColor];
    
    UILabel *label2=[[UILabel alloc] init];
    label2.text=@"禁止,预览音视频可能不同步.最终视频是好的.";
    label2.textColor=[UIColor grayColor];
    
    
    
    uiswitch=[[UISwitch alloc] init];
    uiswitch.tag=301;
    [uiswitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    
    
    [self.view addSubview:label];
    [self.view addSubview:uiswitch];
    
    [self.view addSubview:label2];
    
    
    CGFloat btnWidth=self.view.frame.size.width/3 -15;
    CGFloat btnHeight=40;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    [uiswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(10);
        make.left.mas_equalTo(label.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(uiswitch.mas_bottom);
        make.left.mas_equalTo(label.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, btnHeight));
    }];
}
- (void)switchValueChanged:(UISwitch *)sender
{
    aeCompositionView.disableBuffering=sender.isOn;
}

-(void)onClicked:(UIView *)sender
{
    UIViewController *pushVC=nil;
    switch (sender.tag) {
        case 101:  //替换图片
            [DemoUtils showDialog:@"为演示代码简洁, 暂时不选择图片, 此演示代码公开,请在代码中修改."];
            //  jsonImage0= 图片暂时不变;
            break;
        case 102:  //暂停
            [aeCompositionView pausePreview];
            break;
        case 103:  //恢复
            [aeCompositionView resumePreview];
            break;
            
        case 202:  //后台处理
            //            [aeCompositionView startExport];
        {
            
            [self stopAePreview];
            aeView1=[LSOAeView parseJsonWithPath:json1Path];
            //第二步:给json对象替换各种素材;
            [self replaceAeAsset:aeView1];
            
            [aeView1 updateTextWithOldText:@"临时测试模板--蓝松SDK" newText:@"替换文字123abc..."];
            
            [self startAEComposition];
        }
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UIImage *)createImageWithText2:(NSString *)text imageSize:(CGSize)size txtColor:(UIColor *)textColor
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:60],
                                 NSForegroundColorAttributeName : textColor,
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image  = [self imageFromString:text attributes:attributes size:size];
    return image;
}
/**
 把文字转换为图片;
 @param string 文字,
 @param attributes 文字的属性
 @param size 转换后的图片宽高
 @return 返回图片
 */
- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);  //图片底部颜色;
    CGContextFillRect(context, CGRectMake(0, 0, size.width, 300));
    
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)dealloc
{
    [_hud hide];
    [self stopAePreview];
    NSLog(@"AECompositionDemoVC  dealloc...");
}
@end

