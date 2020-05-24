//
//  LanSongEditor_all
//
//  Created by sno on 2018/6/22.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "AEModuleDemoVC.h"


#import "DemoUtils.h"
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
    
}
@property UILabel *labProgress;

@end

@implementation AEModuleDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    //-------------以下是ui操作-----------------------
    CGSize size=self.view.frame.size;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor blueColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
//    if(_AeType==kAEDEMO_AOBAMA){
//        [self testAobama];
//    }else if(_AeType==kAEDEMO_ZAO_AN){  //早安;
//        [self testZaoan];
//    }else if(_AeType==kAEDEMO_XIANZI){ //紫霞仙子
//        [self testZixianXiaZi];
//    }else{
        [self testJson];
//    }
}
-(void)testAobama
{
//    //奥巴马这个模板, 是先视频层, 再AE层, 最后mv;
    videoURL=[[NSBundle mainBundle] URLForResource:@"aobama" withExtension:@"mp4"];
        //增加AE图层, AE=json+image
        jsonImage0=[self createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
        NSString *jsonName=@"aobama";
        jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
        //开始创建, 先增加一个视频;
    
    
    
    
        drawpadExecute=[[DrawPadAEExecute alloc] init];
    
        //增加背景视频
        [drawpadExecute addBgVideoWithURL:videoURL];
        //增加Ae json层
        LSOAeView *aeView=[drawpadExecute addAEJsonPath:jsonPath];
        [aeView updateImageWithKey:@"image_0" image:jsonImage0];

        //再增加mv图层;
        mvColor=[[NSBundle mainBundle] URLForResource:@"aobama_mvColor" withExtension:@"mp4"];
        mvMask = [[NSBundle mainBundle] URLForResource:@"aobama_mvMask" withExtension:@"mp4"];
        [drawpadExecute addMVPen:mvColor withMask:mvMask];

        //开始执行
        [self startAE];
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
    LSOAeView *aeView1=[drawpadExecute addAEJsonPath:jsonPath];
    
    
    
    
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
        jsonImage0=[UIImage imageNamed:@"zixiaxianzi_img_0"];
        jsonImage1=[UIImage imageNamed:@"zixiaxianzi_img_1"];
    
        //开始创建
        drawpadExecute=[[DrawPadAEExecute alloc] init];
        //增加Ae json层;
        LSOAeView *aeView1=[drawpadExecute addAEJsonPath:jsonPath];
        [aeView1 updateImageWithKey:@"image_0" image:jsonImage0];
        [aeView1 updateImageWithKey:@"image_1" image:jsonImage1];

        //增加mv层;
        if(mvColor!=nil && mvMask!=nil){
            [drawpadExecute addMVPen:mvColor withMask:mvMask];
        }
        [self startAE];  //开始执行;
}
//小鸭子
-(void)testXiaoYa
{
    NSString *jsonName=@"xiaoYa";
    jsonPath= [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    mvColor=[[NSBundle mainBundle] URLForResource:@"xiaoYa_mvColor" withExtension:@"mp4"];
    mvMask = [[NSBundle mainBundle] URLForResource:@"xiaoYa_mvMask" withExtension:@"mp4"];
    
    drawpadExecute=[[DrawPadAEExecute alloc] init];
    LSOAeView *view=[drawpadExecute addAEJsonPath:jsonPath];
    
    
    [view updateImageWithKey:@"image_0" image:[UIImage imageNamed:@"xiaoYa_img_0"]];
    [view updateImageWithKey:@"image_1" image:[UIImage imageNamed:@"xiaoYa_img_1"]];
    [view updateImageWithKey:@"image_2" image:[UIImage imageNamed:@"xiaoYa_img_2"]];
    
    [drawpadExecute addMVPen:mvColor withMask:mvMask];
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
        [DemoUtils showDialog:@"您没有创建Ae容器对象"];
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


/**
 文字转图片

 @param text 文字
 @param size 创建的图片宽高
 @return 返回图片;
 */
-(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:60],
                                 NSForegroundColorAttributeName : [UIColor blueColor],
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image  = [self imageFromString:text attributes:attributes size:size];
    return image;
}
-(UIImage *)createImageWithText2:(NSString *)text imageSize:(CGSize)size
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:60],
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
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);  //图片底部颜色;
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
//测试使用.
-(NSString *)copyAEAssetToSandBox:(NSString *)srcPath dstName:(NSString *)dstName
{
    if(srcPath==nil){
        NSLog(@"copyAEAssetToSandBox error  srcPath is nil");
        return nil;
    }
    NSString *jsonDir=[LSOFileUtil Path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:jsonDir]){  //文件夹不存在则创建这个文件夹;
        [fileManager createDirectoryAtPath:jsonDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * dstPath = [jsonDir stringByAppendingPathComponent:dstName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dstPath])  //如果文件不存在,则拷贝.
    {
        BOOL retVal = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:NULL];
        if (!retVal) {
            NSLog(@"copy %@ asset file Error!,return NULL.",srcPath);
        }
    }
    return jsonDir;
}


-(void) testJson
{
    [self resetData];
    drawpadExecute=[[DrawPadAEExecute alloc] init];
    
    //增加AE图层
    jsonPath= [[NSBundle mainBundle] pathForResource:@"feng_data" ofType:@"json"];
    LSOAeView *aeView=[drawpadExecute addAEJsonPath:jsonPath];
    [aeView updateImageWithKey:@"image_0" image:[UIImage imageNamed:@"feng_img_0"]];
    [aeView updateImageWithKey:@"image_1" image:[UIImage imageNamed:@"feng_img_1"]];




    //开始执行
    [self startAE];
    
}

@end

