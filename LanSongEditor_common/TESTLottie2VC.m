//
//  TESTLottie2VC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/22.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "TESTLottie2VC.h"


#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"
#import "Lottie.h"
#import "VideoPlayViewController.h"


@interface TESTLottie2VC ()
{
    NSMutableArray *mPenArray;
    NSString *dstPath;
    DrawPadVideoExecute *drawpadExecute;
   
}
@property  int  frameCnt;
@property UILabel *labProgress;
@property LOTAnimationView *lottieView;
@end

@implementation TESTLottie2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];

    _frameCnt=0;
    
    //-------------以下是ui操作-----------------------
    CGSize size=self.view.frame.size;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor whiteColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    [self startExecuteDrawPad];
}
//---------------------------
-(void)createLottieView:(CGSize)size
{
    //先创建图片images文件夹和各种图片
    UIImage *image1=[self createImageWithText:@"测试写入文字123abc" imageSize:CGSizeMake(255, 185)];
    
    NSArray *images=[NSArray arrayWithObjects:image1, nil];
    NSString *jsonPath=[self createLottieNeedFiles:@"aobama.json" images:images];
    
    
    //创建Lottie的View
    self.lottieView =[LOTAnimationView animationWithFilePath:jsonPath];
    self.lottieView.contentMode = UIViewContentModeScaleAspectFit;
    self.lottieView.frame=CGRectMake(0, 0,size.width,size.height);
}

/**
 创建lottie需要的两个文件:
 1,json,
 2,和json同一个目录下的images文件夹,
 images文件夹里有img_0.png, img_1.png, img_2.png 等需要的图片文件;
 */
-(NSString *)createLottieNeedFiles:(NSString *)json images:(NSArray *)images
{
    //1, 把json文件拷贝到Docments文件夹下;
    NSString *dstJsonPath=[SDKFileUtil copyResourceFile:@"aobama" withSubffix:@"json" dstDir:@"aobama"];
    
    //2,保存图片到Docments下的images文件夹中;
     NSString *imagesDir=[SDKFileUtil createDirInDocuments:@"aobama/images"];  //先创建
    BOOL success=NO;
    for (int i=0; i<images.count; i++) {
        UIImage *image=[images objectAtIndex:i];
        NSString * string =[NSString stringWithFormat:@"%@/img_%d.png",imagesDir,i];
        success = [UIImagePNGRepresentation(image) writeToFile:string  atomically:YES];
        if (success){
            NSLog(@"写入本地成功:%@",string);
        }else{
            NSLog(@"写入图片失败 :%@",image);
        }
    }
    //4,返回json文件路劲
    if(success){
        return dstJsonPath;
    }else{
        return nil;
    }
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
//创建单色图片
+ (UIImage *)crateImageWithSingleColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width,size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
}
-(void)dealloc{
}

////-------------
-(void)startExecuteDrawPad
{
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"aobamaEx" withExtension:@"mp4"];
    drawpadExecute=[[DrawPadVideoExecute alloc] initWithURL:sampleURL];

    CGSize size=CGSizeMake(drawpadExecute.mediaInfo.vWidth, drawpadExecute.mediaInfo.vHeight);
    [self createLottieView:size];
    
    
    //在视频图层上,增加一个UI图层;
    [drawpadExecute addViewPen:self.lottieView isFromUI:NO];
    
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"ao_color" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"ao_mask" withExtension:@"mp4"];
    [drawpadExecute addMVPen:colorPath withMask:maskPath];
    
    __weak typeof(self) weakSelf = self;
    _frameCnt=0;
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
}
-(void)drawpadProgress:(CGFloat) progress
{
    int percent=(int)(progress*100/drawpadExecute.mediaInfo.vDuration);
     NSLog(@"即将处理时间(进度)是:%f,百分比是:%d",progress,percent);
    _frameCnt++;
    [self.lottieView setProgressWithFrame:[NSNumber numberWithInt:_frameCnt]];
    _labProgress.text=[NSString stringWithFormat:@"   当前进度 %f",progress];
}
-(void)drawpadCompleted:(NSString *)path
{
    dstPath=path;
    drawpadExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}
@end
