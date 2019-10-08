//
//  AECompositionDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/9/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import "AECompositionDemoVC.h"
#import "DemoProgressHUD.h"

@interface AECompositionDemoVC ()
{
    LSOAeCompositionView *aePreview;
    
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    NSURL *bgVideoURL;
    
    NSURL *mvColorURL;
    NSURL *mvMaskURL;
    
    NSString *json1Path;
    NSString *json2Path;
    NSURL *addAudioURL;
    
    NSString *moduleName;
    
   
    
    LSOAeView  *aeView1;
    
    
    BOOL isLSdeleteTESTFile;
}
@property  DemoProgressHUD *hud;
@end

@implementation AECompositionDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    bgVideoURL=nil;
    json1Path=nil;
    mvMaskURL=nil;
    mvColorURL=nil;
    
    _hud=[[DemoProgressHUD alloc] init];
    
    
    [self prepareAeAsset];
    
    
    //替换
    aeView1=[LSOAeCompositionView parseJsonWithPath:json1Path];
    [self replaceAeAsset:aeView1];
    
    
    NSLog(@"aeView  size is :%f x %f",aeView1.jsonWidth, aeView1.jsonHeight);
    
    drawpadSize=CGSizeMake(aeView1.jsonWidth, aeView1.jsonHeight);
    aePreview=[DemoUtils createAeCompositionView:self.view.frame.size drawpadSize:drawpadSize];
    [self.view addSubview:aePreview];
    
    
    UIView *view=[self createButtons:aePreview];
    view=[self newButton:view index:202 hint:@"后台处理(导出)"];
    
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
    
    
    [self startAEPreview];
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
    
    moduleName=nil;
    
    
    switch (_AeType) {
        case kAEDEMO_AOBAMA:
            moduleName=@"aobama";
            bgVideoURL=[[NSBundle mainBundle] URLForResource:moduleName withExtension:@"mp4"];
            break;
        case kAEDEMO_XIANZI:
            moduleName=@"zixiaxianzi";
            break;
        case kAEDEMO_ZAO_AN:
            _AeType=kAEDEMO_ZAO_AN;
            moduleName=@"zaoan";
            break;
        case kEDEMO_XIAOHUANGYA:
            moduleName=@"xiaoYa";
            break;
        case kEDEMO_MORE_PICTURE:
            moduleName=@"morePicture";
            break;
        case kEDEMO_REPLACE_VIDEO:
            moduleName=@"replaceVideo";
            break;
        case kEDEMO_KADIAN:
            moduleName=@"kadian";
            break;
        default:
            [DemoUtils showDialog:@"暂时没有这个举例."];
            [self.navigationController popViewControllerAnimated:YES];
            return;
    }
    if(moduleName!=nil){
        json1Path=[[NSBundle mainBundle] pathForResource:moduleName ofType:@"json"];
        mvColorURL=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_mvColor",moduleName] withExtension:@"mp4"];
        mvMaskURL=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_mvMask",moduleName] withExtension:@"mp4"];
    }
}

-(void)startAEPreview
{
    if(isLSdeleteTESTFile){
        return;
    }
    
    if(aePreview.isRunning){
        return;
    }
    //创建容器(容器是用来放置图层, 所有素材都是一层一层叠加起来处理)
    [aePreview addFirstPenWithURL:bgVideoURL];
    
    //增加json图层;
    [aePreview addSecondPen:aeView1];
    //增加MV图层;
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aePreview addThirdPen:mvColorURL withMask:mvMaskURL];
    }
    
    
    //增加声音图层;[可选]
    if(_AeType==kEDEMO_MORE_PICTURE){
        NSURL *audio=[LSOFileUtil URLForResource:@"morePicture" withExtension:@"mp3"];
        [aePreview addAudio:audio volume:1.0f];
    }else if(_AeType==kEDEMO_KADIAN){
        NSURL *audio=[LSOFileUtil URLForResource:@"kadian" withExtension:@"mp3"];
        [aePreview addAudio:audio volume:1.0f];
    }
    
    
    UIImage *logo=[UIImage imageNamed:@"small"];
    [aePreview addOtherBitmapPen:logo position:kLSOPenLeftTop];
    
    
    //设置循环播放;
    aePreview.loopPlay=YES;
    
//-----------------增加回调---------------------------------------------
    __weak typeof(self) weakSelf = self;
    //预览缓冲回调;
    [aePreview setPreviewBufferingBlock:^(BOOL isBuffering) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isBuffering){
                [weakSelf.hud showProgress:@"正在缓冲..."];
            }else{
                [weakSelf.hud hide];
            }
            
        });
    }];
    
    //预览进度回调;
    [aePreview setPreviewProgressBlock:^(CGFloat progress, CGFloat percent) {
        NSLog(@"------preview progress is :%f, %f",progress, percent);
    }];
    
    //导出进度回调;
    [aePreview setExportProgressBlock:^(CGFloat progress, CGFloat percent) {
        NSLog(@"----setExportProgressBlock is :%f, %f",progress, percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progress percent:percent];
        });
    }];
    
    //导出完成回调;
    [aePreview setExportCompletionBlock:^(NSString *dstPath) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    
    //开始执行,
    [aePreview startPreview];
}
/**
 替换AE中的素材
 */
-(void)replaceAeAsset:(LSOAeView *)aeView
{
    [DemoUtils printJsonInfo:aeView];  //打印json中的信息;
    
    if(moduleName==nil){
        return;
    }
    
    if(aeView!=nil){
        if(_AeType==kAEDEMO_AOBAMA){  //如果是奥巴马模板的话,则直接填入图片;
            UIImage *value=[LSOImageUtil createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
            [aeView updateImageWithKey:@"image_0" image:value];
        }
        else if(_AeType==kAEDEMO_ZAO_AN)
        {
            //早安中的图片,用视频替换来用演示.
            NSURL *videoUrl=[LSOFileUtil URLForResource:@"dy_xialu2" withExtension:@"mp4"];
            [aeView updateVideoImageWithKey:@"image_0" url:videoUrl];
        } else if(_AeType ==kEDEMO_REPLACE_VIDEO){
            NSURL *videoUrl0=[LSOFileUtil URLForResource:@"dy_xialu2" withExtension:@"mp4"];
            NSURL *videoUrl1=[LSOFileUtil URLForResource:@"replaceVideo1" withExtension:@"mp4"];
            NSURL *videoUrl2=[LSOFileUtil URLForResource:@"replaceVideo2" withExtension:@"mp4"];
            
            //第一张图片替换为视频
            [aeView updateVideoImageWithKey:@"image_0" url:videoUrl1];
            
            //第二个视频
            LSOAEVideoSetting *setting=[[LSOAEVideoSetting alloc] init];
            setting.isLooping=YES;
            setting.isFrameRateSameAsJson=NO;
            setting.startTimeS=2;
            setting.endTimeS=8;
            [aeView updateVideoImageWithKey:@"image_1" url:videoUrl0 setting:setting];
            
            //第三个视频
            [aeView updateVideoImageWithKey:@"image_2" url:videoUrl2];
            
            //[aeView setVideoImageFrameBlock:@"image_0" updateblock:^UIImage * _Nonnull(NSString * _Nonnull imgId, CGFloat framePts, UIImage * _Nonnull image) {
            //   return image;
            //}];
            [aeView updateTextWithOldText:@"临时测试模板--蓝松SDK" newText:@"123abcdefg蓝松科技有限公司456"];
        }else{
            //因为我们提供的模板文件名和图片ID是一一对应的. 比如图片ID="image_0"的图片, 他对应的替换图片是xxx_img_0, 则我们有规律
            //所有这里可以用for循环来替, 如果你的图片没有规律,则分别创建成value
            
            for (int i=0; i<aeView.imageInfoArray.count; i++) {
                NSString *key=[NSString stringWithFormat:@"image_%d",i];
                NSString *name= [NSString stringWithFormat:@"%@_img_%d",moduleName,i];
                
                NSURL *imageURL=[LSOFileUtil URLForResource:name withExtension:@"png"];
                [aeView updateImageWithKey:key imageURL:imageURL];
            }
            
        }
    }
}
-(void)stopAePreview
{
    if (aePreview!=nil) {
        [aePreview cancel];
        aePreview=nil;
    }
}
-(void)drawpadProgress:(CGFloat) progress percent:(CGFloat)percent
{
    [_hud showProgress:[NSString stringWithFormat:@"进度:%f",percent]];
}
-(void)drawpadCompleted:(NSString *)path
{
    [_hud hide];
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}
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
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.tag=tag;
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
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
            [aePreview pausePreview];
            break;
        case 103:  //恢复
            [aePreview resumePreview];
            break;
            
        case 202:  //后台处理
            [aePreview startExport];
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
    LSOLog_d(@"AECompositionDemoVC  dealloc...");
}

@end

