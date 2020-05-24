//
//  AEPreviewDemo.m
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "AEPreviewDemoVC.h"
#import "DemoProgressHUD.h"

@interface AEPreviewDemoVC ()
{
    DrawPadAEPreview *aePreview;
    DrawPadAEExecute *aeExecute;
    
    LanSongView2 *lansongView;
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
    
    DemoProgressHUD *hud;
    
    unsigned char *rawBytes;
}
@end

@implementation AEPreviewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor lightGrayColor];
    
    bgVideoURL=nil;
    json1Path=nil;
    mvMaskURL=nil;
    mvColorURL=nil;

    hud=[[DemoProgressHUD alloc] init];

        [self prepareAeAsset];
        [self startAEPreview];
    
  
    
    UIView *view=[self newButton:lansongView index:201 hint:@"替换图片"];
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
}

-(void)viewDidAppear:(BOOL)animated
{
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAeExecute];
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
    if(aePreview.isRunning){
        return;
    }

    [self stopAePreview];
    [self stopAeExecute];

    //创建容器(容器是用来放置图层, 所有素材都是一层一层叠加起来处理)
    
    aePreview=[[DrawPadAEPreview alloc] init];
    
    //增加一层视频层
    if(bgVideoURL!=nil){
        [aePreview addBgVideoWithURL:bgVideoURL];
    }
    //增加json图层;
    LSOAeView *aeView=[aePreview addAEJsonPath:json1Path];
    [self replaceAeAsset:aeView];

    //增加MV图层;
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aePreview addMVPen:mvColorURL withMask:mvMaskURL];
    }
    //容器大小,在增加图层后获取;
    drawpadSize=aePreview.drawpadSize;
    if(lansongView==nil){
        lansongView=[DemoUtils createLanSongView:self.view.frame.size drawpadSize:drawpadSize];
        [self.view addSubview:lansongView];
    }
    [aePreview addLanSongView:lansongView];
    
    
    //增加声音图层;[可选]
    if(_AeType==kEDEMO_MORE_PICTURE){
        NSURL *audio=[LSOFileUtil URLForResource:@"morePicture" withExtension:@"mp3"];
        [aePreview addAudio:audio volume:1.0f];
    }else if(_AeType==kEDEMO_KADIAN){
        NSURL *audio=[LSOFileUtil URLForResource:@"kadian" withExtension:@"mp3"];
        [aePreview addAudio:audio volume:1.0f];
    }
    //增加回调
    __weak typeof(self) weakSelf = self;
    [aePreview setProgressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progress];
        });
    }];

    [aePreview setCompletionBlock:^(NSString *path) {
          dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf startAEPreview];  //如果没有编码,则让他循环播放
              });
    }];
    
    //开始执行,
    [aePreview start];
}

/**
 后台执行
 */
-(void)startAeExecute
{
    [self stopAePreview];
    [self stopAeExecute];
    
    //1.创建对象;
     aeExecute=[[DrawPadAEExecute alloc] init];
    
    //增加背景视频层;[可选]
    if(bgVideoURL!=nil){
        [aeExecute addBgVideoWithURL:bgVideoURL];
    }

    //2.增加json层
    if(json1Path!=nil){
        LSOAeView *aeView=[aeExecute addAEJsonPath:json1Path];
        [self replaceAeAsset:aeView];
    }

    //3.再增加mv图层;[可选]
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aeExecute addMVPen:mvColorURL withMask:mvMaskURL];
    }
    LSDELETE(@"--------更新视频----大发发大---->")
    
    
    //增加声音图层;[可选]
    if(_AeType==kEDEMO_MORE_PICTURE){
        NSURL *audio=[LSOFileUtil URLForResource:@"morePicture" withExtension:@"mp3"];
        [aeExecute addAudio:audio volume:1.0f];
    }else if(_AeType==kEDEMO_KADIAN){
        NSURL *audio=[LSOFileUtil URLForResource:@"kadian" withExtension:@"mp3"];
        [aeExecute addAudio:audio volume:1.0f];
    }
    
    //4.设置回调
    WS(weakSelf)
    [aeExecute setProgressBlock:^(CGFloat progess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progess];
        });
    }];
    
    [aeExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    //5.开始执行
    [aeExecute start];
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
                setting.startTimeS=2;
                setting.endTimeS=8;
                [aeView updateVideoImageWithKey:@"image_1" url:videoUrl0 setting:setting];

                //第三个视频
                [aeView updateVideoImageWithKey:@"image_2" url:videoUrl2];

//                [aeView setVideoImageFrameBlock:@"image_0" updateblock:^UIImage * _Nonnull(NSString * _Nonnull imgId, CGFloat framePts, UIImage * _Nonnull image) {
//                    return image;
//                }];
            
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
-(void)stopAeExecute
{
    [hud hide];
    if (aeExecute!=nil) {
        [aeExecute cancel];
        aeExecute=nil;
    }
}

-(void)drawpadProgress:(CGFloat) progress
{
    if(aePreview!=nil){
        int percent=(int)(progress*100/aePreview.duration);
        labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
    }else if(aeExecute!=nil){
        int percent=(int)(progress*100/aeExecute.duration);
        [hud showProgress:[NSString stringWithFormat:@"进度:%d",percent]];
    }else{
    }
}
-(void)drawpadCompleted:(NSString *)path
{
    aeExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [hud hide];
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
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case 201:  //替换图片
            [DemoUtils showDialog:@"为演示代码简洁, 暂时不选择图片, 此演示代码公开,请在代码中修改."];
            //  jsonImage0= 图片暂时不变;
             break;
        case 202:  //后台处理
            [self startAeExecute];
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
    [self stopAeExecute];
    [self stopAePreview];
    NSLog(@"AEPreviewDemoVC  dealloc...");
}
@end

