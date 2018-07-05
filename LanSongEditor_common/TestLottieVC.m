//
//  TestLottieVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "TestLottieVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"
#import "Lottie.h"
#import "VideoPlayViewController.h"


@interface TestLottieVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    LanSongView2 *lansongView;
    CGSize drawpadSize;
}
@property (nonatomic, strong) LOTAnimationView *lottieView;
@end

@implementation TestLottieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"mayun" withExtension:@"mp4"];
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithURL:sampleURL];
    drawpadSize=drawpadPreview.drawpadSize;
    
    CGSize size=self.view.frame.size;
    
    
    //先增加一个lottieUI界面, 然后用lansongView挡着这个界面;
    [self createLottieView];
    
    //显示窗口
    lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
    [self.view addSubview:lansongView];
    [drawpadPreview addLanSongView:lansongView];
    
    [self initView];
    
    //增加UI图层;
    [drawpadPreview addViewPen:self.lottieView isFromUI:NO];
    
    
    //增加Bitmap
    UIImage *image=[UIImage imageNamed:@"mm"];
    [drawpadPreview addBitmapPen:image];


    //增加MV图层
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
    [drawpadPreview addMVPen:colorPath withMask:maskPath];
    
    //进度完成回调
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progess) {
        
        NSLog(@"progress  is :%f",progess);
        
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
            vce.videoPath=dstPath;
            [weakSelf.navigationController pushViewController:vce animated:NO];
            
        });
    }];
    [drawpadPreview startWithEncode];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if(drawpadPreview!=nil){
        [drawpadPreview startWithEncode];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
    }
}
//---------------------------
-(void)createLottieView
{
    if(self.lottieView!=nil){
        [self.lottieView removeFromSuperview];
        self.lottieView = nil;
    }
    
    //先创建图片images文件夹和各种图片
    NSString *filePath=[self createFilePath];
    
    //拷贝数据;
    NSString * jsonPath  =[NSString stringWithFormat:@"%@/dammta.json",filePath];
    NSString * srcPath = [[NSBundle mainBundle] pathForResource:@"dammta" ofType:@"json"];
    BOOL filesPresent = [self copyMissingFile:srcPath toPath:jsonPath];
    if (filesPresent==NO) {
        NSLog(@"文件拷贝失败....");
    }
    
    /*
     加载这里的FilePath 文件结构是 一个json文件,
     和同一级目录有一个images文件夹, images中放的是使用到的图片;
     */
    self.lottieView =[LOTAnimationView animationWithFilePath:jsonPath];
    
    self.lottieView.contentMode = UIViewContentModeScaleAspectFit;
    self.lottieView.frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.width*480/640);
    
    [_lottieView setProgressWithFrame: [NSNumber numberWithInt:5]];
    
    [self.view addSubview:self.lottieView];
    [self.view setNeedsLayout];
    self.lottieView.loopAnimation=YES;
    [self.lottieView playWithCompletion:^(BOOL animationFinished) {
    }];
}
-(NSString *)createFilePath
{
    //创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/images",str1];
    
    //如果文件不存在
    if(![fileManager fileExistsAtPath:filePath]){
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSString *directryPath = [path stringByAppendingPathComponent:@"images"];
        NSLog(@"directryPath is:%@",directryPath);
        
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        filePath =directryPath;
    }
    
    for (int i =0; i <5; i ++) {
        
        //这里其实是文字转图片;
        NSString *string1 = @"增加对话框, 写入文字129090";
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [paragraphStyle setLineSpacing:15.f];  //行间距
        [paragraphStyle setParagraphSpacing:2.f];//字符间距
        
        NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:30],
                                     NSForegroundColorAttributeName : [UIColor blueColor],
                                     NSBackgroundColorAttributeName : [UIColor clearColor],
                                     NSParagraphStyleAttributeName : paragraphStyle, };
        
        
        UIImage *image  = [self imageFromString:string1 attributes:attributes size:CGSizeMake(320, 240)];
        
        NSString * string =[NSString stringWithFormat:@"%@/img_%d.png",filePath,i];
        BOOL success = [UIImagePNGRepresentation(image) writeToFile:string  atomically:YES];
        if (success){
            //            NSLog(@"写入本地成功:%d",i);
        }else{
            NSLog(@"写入图片失败 :%@",image);
        }
    }
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
/**
 *    @brief    把Resource文件夹下的save1.dat拷贝到沙盒
 *
 *    @param     sourcePath     Resource文件路径
 *    @param     toPath     把文件拷贝到XXX文件夹
 *    @return    BOOL
 */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:toPath error:NULL];
    }
    return retVal;
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
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
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
    UILabel *labHint=[[UILabel alloc] init];
    labHint.text=@"建立容器后,增加3个图层:\n UI图层(Lottie还原的AE模板) 图片图层  MV图层";
    labHint.numberOfLines=8;
    [self.view addSubview:labHint];
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 80));
    }];
}
-(void)dealloc{
    drawpadPreview=nil;
    lansongView=nil;
}
@end
