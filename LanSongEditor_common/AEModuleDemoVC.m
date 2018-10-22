//
//  LanSongEditor_all
//
//  Created by sno on 2018/6/22.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "AEModuleDemoVC.h"


#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"
#import "VideoPlayViewController.h"

@interface AEModuleDemoVC ()
{
    NSMutableArray *mPenArray;
    NSString *dstPath;
    DrawPadAEExecute *drawpadExecute;
    
    
    NSURL *videoURL;
    NSURL *mvColor;
    NSURL *mvMask;
    NSString *jsonPath;
    UIView *view;
    
    UIImage *jsonImage0;
    UIImage *jsonImage1;
    
    MediaInfo *mediaInfo;
}
@property UILabel *labProgress;

@end

@implementation AEModuleDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    
    //-------------以下是ui操作-----------------------
    CGSize size=self.view.frame.size;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor whiteColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    if(_AeType==AEDEMO_AOBAMA){
        [self testAobama];
    }else if(_AeType==AEDEMO_ZAO_AN){  //早安;
        [self testZaoan];
    }else if(_AeType==AEDEMO_XIANZI){ //紫霞仙子
        [self testZixianXiaZi];
    }else{
        [self testJson];
    }
}
-(void)testAobama
{
//    //奥巴马这个模板, 是先视频层, 再AE层, 最后mv;
    videoURL=[[NSBundle mainBundle] URLForResource:@"aobamaEx" withExtension:@"mp4"];
    mediaInfo=[[MediaInfo alloc] initWithPath:[LanSongFileUtil urlToFileString:videoURL]];
    if([mediaInfo prepare]){

        //增加AE图层, AE=json+image
        jsonImage0=[self createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
        NSString *jsonName=@"aobama";
        jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
        //开始创建, 先增加一个视频;
        drawpadExecute=[[DrawPadAEExecute alloc] initWithURL:videoURL];
        //增加Ae json层
        LSOAnimationView *aeView=[drawpadExecute addAEJsonPath:jsonPath];
        [aeView updateImageWithKey:@"image_0" image:jsonImage0];

        //再增加mv图层;
        mvColor=[[NSBundle mainBundle] URLForResource:@"ao_color" withExtension:@"mp4"];
        mvMask = [[NSBundle mainBundle] URLForResource:@"ao_mask" withExtension:@"mp4"];
        [drawpadExecute addMVPen:mvColor withMask:mvMask];

        //开始执行
        [self startAE];
    }
}
-(void)testZaoan
{
    //    //素材有4个;
    NSString *jsonName=@"zaoan";
    mvColor=[[NSBundle mainBundle] URLForResource:@"zaoan_mvColor" withExtension:@"mp4"];
    mvMask=[[NSBundle mainBundle] URLForResource:@"zaoan_mvMask" withExtension:@"mp4"];
     jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    jsonImage0=[UIImage imageNamed:@"zaoan"];
    
    drawpadExecute=[[DrawPadAEExecute alloc] init];
    //增加Ae json层;
    LSOAnimationView *aeView1=[drawpadExecute addAEJsonPath:jsonPath];
    if(jsonImage0!=nil){
        [aeView1 updateImageWithKey:@"image_0" image:jsonImage0];
    }
    
    //增加mv层;
    [drawpadExecute addMVPen:mvColor withMask:mvMask];
    [self startAE];  //开始执行;
}
/**
 AE模板类型:
 先增加 json层; 后增加mv层
 */
-(void)testZixianXiaZi
{
//    //素材有4个;
        NSString *jsonName=@"zixiaxianzi";
        mvColor=[[NSBundle mainBundle] URLForResource:@"zixiaxianzi_mvColor" withExtension:@"mp4"];
        mvMask=[[NSBundle mainBundle] URLForResource:@"zixiaxianzi_mvMask" withExtension:@"mp4"];
        jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    //开始创建
        drawpadExecute=[[DrawPadAEExecute alloc] init];
        //增加Ae json层;
        LSOAnimationView *aeView1=[drawpadExecute addAEJsonPath:jsonPath];
        [aeView1 updateImageWithKey:@"image_0" image:[UIImage imageNamed:@"zixiaxianzi_img0"]];
        [aeView1 updateImageWithKey:@"image_1" image:[UIImage imageNamed:@"zixiaxianzi_img1"]];

        //增加mv层;
        if(mvColor!=nil && mvMask!=nil){
            [drawpadExecute addMVPen:mvColor withMask:mvMask];
        }
        [self startAE];  //开始执行;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)startAE
{
    if(drawpadExecute!=nil){
        __weak typeof(self) weakSelf = self;
        [drawpadExecute setProgressBlock:^(CGFloat progess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf drawpadProgress:progess];
            });
        }];
        
        [drawpadExecute setCompletionBlock:^(NSString *dstPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf drawpadCompleted:dstPath];
            });
        }];
        
        [drawpadExecute start];
    }else{
        [LanSongUtils showDialog:@"您没有创建Ae容器对象"];
    }
}
-(void)drawpadProgress:(CGFloat) progress
{
    int percent=(int)(progress*100/drawpadExecute.duration);
    _labProgress.text=[NSString stringWithFormat:@"   当前进度 %f,百分比是:%d",progress,percent];
}
-(void)drawpadCompleted:(NSString *)path
{
    dstPath=path;
    drawpadExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}


-(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:30],
                                 NSForegroundColorAttributeName : [UIColor blueColor],
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
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, 300));
    
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)dealloc{
}
-(void)resetData
{
    jsonPath=nil;
    mvMask=nil;
    mvColor=nil;
    videoURL=nil;
    jsonImage0=nil;
    jsonImage1=nil;
}
-(void) testJson
{
    [self resetData];
    
    NSString *jsonName=@"test_image3";
    jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];

    //开始创建
    drawpadExecute=[[DrawPadAEExecute alloc] init];
    //增加Ae json层;
    LSOAnimationView *aeView1=[drawpadExecute addAEJsonPath:jsonPath];
    [aeView1 updateImage:@"image_0" image:[UIImage imageNamed:@"test_image3_img_0"]];
    [aeView1 updateImage:@"image_1" image:[UIImage imageNamed:@"test_image3_img_1"]];
    [aeView1 updateImage:@"image_2" image:[UIImage imageNamed:@"test_image3_img_2"]];
    
    [self startAE];  //开始执行;
}
@end

