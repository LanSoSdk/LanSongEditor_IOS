//
//  TestLottieVC3.m
//  LanSongEditor_all
//
//  Created by sno on 2018/5/24.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "TestLottieVC3.h"
#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"
#import "Lottie.h"
#import "VideoPlayViewController.h"


@interface TestLottieVC3 ()
{
    DrawPadVideoPreview *drawpadPreview;
    NSString *inputText; //输入的文字;
}
@property (nonatomic, strong) LOTAnimationView *lottieView;
@end

@implementation TestLottieVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    [self showDialog];
}
-(void)startDrawPad
{
    CGSize size=self.view.frame.size;
    //640, 480是mayun.mp4这个视频的分辨率;
    int drawPadWidth=640;
    int drawPadHeight=480;
    CGSize drawpadSize=CGSizeMake(drawPadWidth, drawPadHeight);
    LanSongView *previewView=[[LanSongView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*drawPadHeight/drawPadWidth)];
    
    [self.view addSubview:previewView];
    
    //创建容器
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithSize:drawpadSize view:previewView];
    
    
    
    //增加视频图层;
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"mayun" withExtension:@"mp4"];
    [drawpadPreview addVideoPenWithURL:sampleURL];
    
    //增加UI图层;
    [self createLottieView];
    [drawpadPreview addViewPen:self.lottieView isFromUI:YES];
    
    
    __weak typeof(self) this = self;
    [drawpadPreview setProgressBlock:^(CGFloat progess) {
        
        NSLog(@"progress  is :%f",progess);
        
    }];
    [drawpadPreview setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
            vce.videoPath=dstPath;
            [this.navigationController pushViewController:vce animated:NO];
            
        });
    }];
    
    //开始执行
    [drawpadPreview start];
}
-(void)createLottieView
{
    if(self.lottieView!=nil){
        [self.lottieView removeFromSuperview];
        self.lottieView = nil;
    }
    
    //先创建图片images文件夹和各种图片
    NSString *filePath=[self createImagePath:inputText];
    
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
    [self.view addSubview:self.lottieView];
    [self.view setNeedsLayout];
    self.lottieView.loopAnimation=YES;
    [self.lottieView playWithCompletion:^(BOOL animationFinished) {
    }];
}
//---------------------------
-(NSString *)createImagePath:(NSString *)text
{
    //创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/images",str1];
    
    //如果文件不存在
    if(![fileManager fileExistsAtPath:filePath]){
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"images"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        filePath =directryPath;
    }
    
    
        //这里其实是文字转图片;
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [paragraphStyle setLineSpacing:15.f];  //行间距
        [paragraphStyle setParagraphSpacing:2.f];//字符间距
        
        NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:30],
                                     NSForegroundColorAttributeName : [UIColor blueColor],
                                     NSBackgroundColorAttributeName : [UIColor clearColor],
                                     NSParagraphStyleAttributeName : paragraphStyle, };
        
    
    //字符串转图片
        UIImage *image  = [self imageFromString:text attributes:attributes size:CGSizeMake(320, 240)];
    
    //图片保存到 img_0.png位置;
        NSString * string =[NSString stringWithFormat:@"%@/img_0.png",filePath];
        BOOL success = [UIImagePNGRepresentation(image) writeToFile:string  atomically:YES];
        if (success){
//            NSLog(@"写入本地成功:%d",i);
        }else{
            NSLog(@"写入图片失败 :%@",image);
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
-(void)showDialog
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入要替换的文字" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"替换文字";
    alert.tag=101;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101){
        if(buttonIndex==1){
            UITextField *txt = [alertView textFieldAtIndex:0];
            NSLog(@" 拿到的数据是:%@",txt.text);
            inputText=txt.text;
            if(inputText!=nil){
                [self startDrawPad];
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
