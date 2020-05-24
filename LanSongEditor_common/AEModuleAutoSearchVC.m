//
//  AEModuleAutoSearchVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/4/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import "AEModuleAutoSearchVC.h"

#import "DemoUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"
#import "VideoPlayViewController.h"

@interface AEModuleAutoSearchVC ()
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

@implementation AEModuleAutoSearchVC

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
    
//        if(_AeType==kAEDEMO_AOBAMA){
//            [self testAobama];
//        }else if(_AeType==kAEDEMO_ZAO_AN){  //早安;
//            [self testZaoan];
//        }else if(_AeType==kAEDEMO_XIANZI){ //紫霞仙子
//            [self testZixianXiaZi];
//        }else{
    [self testJson];
//        }
}
-(void)testAobama
{
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
-(void) testJson
{
    [self resetData];
    [self saveAssetToDir];
    
    //-------------一下是正式开始...
    
    //第一步, z先找到文件;
        NSString *dirPath=[NSString stringWithFormat:@"%@/aobama",[LSOFileUtil Path]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:dirPath error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {  //列出当前文件夹下的所有文件;
            [self parseFileName:filename dirPath:dirPath];
        }
    
    
    
        //开始创建, 先增加一个视频;
        drawpadExecute=[[DrawPadAEExecute alloc] init];
    
        if(videoURL!=nil){
            [drawpadExecute addBgVideoWithURL:videoURL];
        }
    
        //增加Ae json层
        LSOAeView *aeView=[drawpadExecute addAEJsonPath:jsonPath];
    
//        for(LSOAeImage *info in aeView.imageInfoArray){
//            NSLog(@"id:%@, width:%d %d, name:%@",info.imgId,info.imgWidth,info.imgHeight,info.imgName);
//        }

    [aeView updateImageByName:@"img_0.png" image:jsonImage0];  //<----通过名字来替换图片.
        
        //再增加mv图层;
        [drawpadExecute addMVPen:mvColor withMask:mvMask];
        
        //开始执行
        [self startAE];
}

/**
 把各种资源放到同一个文件夹里.
 */
-(void)saveAssetToDir
{
    NSString *video1=[LSOFileUtil pathForResource:@"aobama" ofType:@"mp4"];
    NSString *mvColor=[LSOFileUtil pathForResource:@"aobama_mvColor" ofType:@"mp4"];
    NSString *mvMask=[LSOFileUtil pathForResource:@"aobama_mvMask" ofType:@"mp4"];
    NSString *jsonPath=[LSOFileUtil pathForResource:@"aobama" ofType:@"json"];
    UIImage *jsonImage0=[LSOImageUtil createImageWithText:@"演示微商小视频,文字可以任意修改,可以替换为图片,可以替换为视频;" imageSize:CGSizeMake(255, 185)];
    NSString *dirPath=[self copyAEAssetToDir:@"aobama" srcPath:video1 dstFileName:@"aobama_c1.mp4"];
    dirPath=[self copyAEAssetToDir:@"aobama" srcPath:jsonPath dstFileName:@"aobama_c2.json"];
    dirPath= [self copyAEAssetToDir:@"aobama" srcPath:mvColor dstFileName:@"aobama_c3_mvColor.mp4"];
    dirPath=[self copyAEAssetToDir:@"aobama" srcPath:mvMask dstFileName:@"aobama_c3_mvMask.mp4"];
    NSData *dataForPNGFile = UIImagePNGRepresentation(jsonImage0);
    NSString *path=[dirPath stringByAppendingPathComponent:@"/img_0.png"];

    
    NSError *error = nil;
    [dataForPNGFile writeToFile:path options:NSAtomicWrite error:&error];
}

/**
 解析文件名字
 */
-(void)parseFileName:(NSString *)fileName dirPath:(NSString *)dir
{
     NSString *filePath=[NSString stringWithFormat:@"%@/%@",dir,fileName];
    if(fileName==nil || [LSOFileUtil  fileExist:filePath]==NO){
        return ;
    }
    
    NSString *fileSuffix=[fileName pathExtension];
    if(fileSuffix==nil){
        return;
    }
    if([fileSuffix isEqualToString:@"jpg"] || [fileSuffix isEqualToString:@"png"] ||[fileSuffix isEqualToString:@"jpeg"]){
        
        NSString *imagePath=[NSString stringWithFormat:@"%@/%@",dir,fileName];
        UIImage *image=[[UIImage alloc] initWithContentsOfFile:imagePath];
        if(image!=nil){
            jsonImage0=image;
        }else{
            NSLog(@"image is nil---------");
        }
        
    }else if([fileSuffix isEqualToString:@"mp3"] ||[fileSuffix isEqualToString:@"m4a"]){
        NSLog(@"暂时没有单独声音的演示.");
    }else if([fileName containsString:@"_c"]){
        
        NSRange range=[fileName rangeOfString:@"_c"];
        NSString  *number = [fileName  substringFromIndex:range.location+range.length];
        
        int index=[number intValue];
        NSLog(@"当前在第 %d 层",index);
        if([fileSuffix isEqualToString:@"mp4"]){
            if([fileName containsString:@"mvColor"]){
                 mvColor=[LSOFileUtil filePathToURL:filePath];
            }else if([fileName containsString:@"mvMask"]){
                mvMask=[LSOFileUtil filePathToURL:filePath];
            }else{
                videoURL=[LSOFileUtil filePathToURL:filePath];
            }
        }else if([fileSuffix isEqualToString:@"json"]){
            jsonPath=filePath;
        }else{
            NSLog(@"暂时不支持这种类型");
        }
    }
}
-(NSString *)copyAEAssetToDir:(NSString *)dirName srcPath:(NSString *)srcPath dstFileName:(NSString *)dstName
{
    if(srcPath==nil){
        NSLog(@"copyAEAssetToDir error  srcPath is nil");
        return nil;
    }
    NSString *jsonDir=[NSString stringWithFormat:@"%@/%@",[LSOFileUtil Path],dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:jsonDir]){  //文件夹不存在则创建这个文件夹;
        [fileManager createDirectoryAtPath:jsonDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * finalLocation = [jsonDir stringByAppendingPathComponent:dstName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])  //如果文件不存在,则拷贝.
    {
        BOOL retVal = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:finalLocation error:NULL];
        if (!retVal) {
            NSLog(@"copy %@ asset file Error!,return NULL.",srcPath);
        }
    }
    return jsonDir;
}
-(NSString *)copyAEAssetToSandBox:(NSString *)srcPath dstFileName:(NSString *)dstName
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
@end

