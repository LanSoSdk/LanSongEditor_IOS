//
//  AEPreviewDemo.m
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "AEPreviewDemoVC.h"
#import "LSOProgressHUD.h"

@interface AEPreviewDemoVC ()
{
    DrawPadAEPreview *aePreview;
    DrawPadAEExecute *aeExecute;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    LSOVideoPen *videoPen;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    NSURL *bgVideoURL;
    
    NSURL *mvColorURL;
    NSURL *mvMaskURL;
    
    NSString *json1Path;
    NSURL *addAudioURL;
    
    NSString *moduleName;
}
@end

@implementation AEPreviewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor lightGrayColor];
    
    bgVideoURL=nil;
    json1Path=nil;
    bgVideoURL=nil;
    mvMaskURL=nil;
    mvColorURL=nil;
    
    [self createData];
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
-(void)createData
{
    bgVideoURL=nil;
    switch (_AeType) {
        case kAEDEMO_AOBAMA:
            moduleName=@"aobama";
            bgVideoURL=[[NSBundle mainBundle] URLForResource:moduleName withExtension:@"mp4"];
            break;
        case kAEDEMO_XIANZI:
            moduleName=@"zixiaxianzi";
            break;
        case kAEDEMO_ZAO_AN:
            moduleName=@"zaoan";
            break;
        case kEDEMO_XIAOHUANGYA:
            moduleName=@"xiaoYa";
            break;
        default:
            [LanSongUtils showDialog:@"暂时没有这个举例."];
            return;
    }
}

-(void)startAEPreview
{
    [self stopAePreview];
    [self stopAeExecute];
    
//    //1.创建容器(容器是用来放置图层, 所有素材都是一层一层叠加起来处理)
    if(bgVideoURL!=nil){
         aePreview=[[DrawPadAEPreview alloc] initWithURL:bgVideoURL];
    }else{
        aePreview=[[DrawPadAEPreview alloc] init];
    }

    //2.增加json图层;
    [self addAeJsonLayer];


    //容器大小,在增加图层后获取;
    drawpadSize=aePreview.drawpadSize;
    //3.创建显示窗口
    CGSize size=self.view.frame.size;
    if(lansongView==nil){
        lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
        [self.view addSubview:lansongView];  //显示窗口增加到ui上;
    }
    [aePreview addLanSongView:lansongView];

    [self addMVLayer];
 //---------------------------------------------------
    //5.增加回调
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
    videoPen=aePreview.videoPen;
    
    //6.开始执行,
    [aePreview start];
}

/**
 增加Ae json图层;
 */
-(void)addAeJsonLayer
{
    json1Path=[[NSBundle mainBundle] pathForResource:moduleName ofType:@"json"];
    if(json1Path!=nil){
        LSOAeView *jsonView=[aePreview addAEJsonPath:json1Path];
        
        if([moduleName isEqualToString:@"aobama"]){  //如果是奥巴马模板的话,则直接填入图片;
            UIImage *value=[LSOImageUtil createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
            [jsonView updateImageWithKey:@"image_0" image:value];
        }else{ //给解析到的json替换图片
            for (int i=0; i<jsonView.imageInfoArray.count; i++) {
                NSString *key=[NSString stringWithFormat:@"image_%d",i];
                UIImage *value=[UIImage imageNamed:[NSString stringWithFormat:@"%@_img_%d",moduleName,i]];
                [jsonView updateImageWithKey:key image:value];
            }
        }
    }
}

/**
 增加MV图层;
 */
-(void)addMVLayer
{
    mvColorURL=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_mvColor",moduleName] withExtension:@"mp4"];
    mvMaskURL=[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_mvMask",moduleName] withExtension:@"mp4"];
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aePreview addMVPen:mvColorURL withMask:mvMaskURL];
    }
}

/**
 后台执行
 */
-(void)startAeExecute
{
    [self stopAePreview];
    [self stopAeExecute];
    
    if(bgVideoURL!=nil){
         aeExecute=[[DrawPadAEExecute alloc] initWithURL:bgVideoURL];
    }else{
        aeExecute=[[DrawPadAEExecute alloc] init];
    }
    
    //增加json层
    json1Path=[[NSBundle mainBundle] pathForResource:moduleName ofType:@"json"];
    if(json1Path!=nil){
        LSOAeView *aeView=[aeExecute addAEJsonPath:json1Path];
        if([moduleName isEqualToString:@"aobama"]){  //如果是奥巴马模板的话,则直接填入图片;
            UIImage *value=[LSOImageUtil createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
            [aeView updateImageWithKey:@"image_0" image:value];
        }else{
            for (int i=0; i<aeView.imageInfoArray.count; i++) {
                NSString *key=[NSString stringWithFormat:@"image_%d",i];
                UIImage *value=[UIImage imageNamed:[NSString stringWithFormat:@"%@_img_%d",moduleName,i]];
                [aeView updateImageWithKey:key image:value];
            }
        }
    }
    //再增加mv图层;
    if(mvColorURL!=nil && mvMaskURL!=nil){
        [aeExecute addMVPen:mvColorURL withMask:mvMaskURL];
    }
    
    //开始执行
    __weak typeof(self) weakSelf = self;
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
    [aeExecute start];
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
        labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
    }else{
    }
}
-(void)drawpadCompleted:(NSString *)path
{
    aeExecute=nil;
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
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case 201:  //替换图片
            [LanSongUtils showDialog:@"为演示代码简洁, 暂时不选择图片, 此演示代码公开,请在代码中修改."];
            //  jsonImage0= 图片暂时不变;
             break;
        case 202:  //后台处理
            [self startAeExecute];
             break;
        default:
            break;
    }
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
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
}
@end
