//
//  DemoUtils.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "DemoUtils.h"
#import <LanSongEditorFramework/LanSongEditor.h>

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "VideoPlayViewController.h"

@implementation DemoUtils


+(void)showDialog:(NSString *)str
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
+(void) showHUDToast:(NSString *)strHint
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.mode=MBProgressHUDModeDeterminate;
    HUD.labelText=strHint;
    [HUD hide:YES afterDelay:1];
}

/**
 [DemoUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];

 @param nav
 @param dstPath <#dstPath description#>
 */
+(void)startVideoPlayerVC:(UINavigationController*)nav dstPath:(NSString *)dstPath
{
    if ([LSOFileUtil fileExist:dstPath]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstPath;
        [nav pushViewController:videoVC animated:NO];
    }else{
        NSString *str=[NSString stringWithFormat:@"文件不存在:%@",dstPath];
        [DemoUtils showHUDToast:str];
    }
}

+ (void)setView:(UIView *)view toSizeWidth:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginX:(CGFloat)x
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOrigin:(CGPoint)origin
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

+ (BOOL)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            LSOLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFolderPathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    return path;
}



//--------------------
+ (CGImageRef)imageRefFromBGRABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 8,
                                                 imageSize.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}
+ (UIImage *)imageFromBRGABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    CGImageRef imageRef = [DemoUtils imageRefFromBGRABytes:imageBytes imageSize:imageSize];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

/**
 根据容器大小, 计算应该显示多少到界面上;
 里面默认位置在:0,60;
 代码请自行修改,以满足你的需求;
 @param fullSize self.view.frame.size(当前ViewController的大小)
 @param padSize 容器大小
 @return 得到的容器显示view
 */
+(LanSongView2 *)createLanSongView:(CGSize)fullSize drawpadSize:(CGSize)padSize
{
    if(padSize.width>0  && padSize.height>0){
        LanSongView2  *retView=nil;
        
        if (padSize.width>padSize.height) {  //横屏
            retView=[[LanSongView2 alloc] initWithFrame:CGRectMake(0, 90, fullSize.width,fullSize.width*(padSize.height/padSize.width))];
        }else{  //竖屏
            //如果高度大于宽度,则使用屏幕的高度一半作为预览界面.同时为了保证预览的画面宽高比一致,等比例得到宽度的值.
            retView=[[LanSongView2 alloc] initWithFrame:CGRectMake(0,90, fullSize.height*(padSize.width/padSize.height)/2,
                                                                   fullSize.height/2)];
            
            
            retView.center=CGPointMake(fullSize.width/2, retView.center.y);
        }
        return retView;
    }else{
        LSOLog_e(@"createLanSongView ERROR,pad size is error !")
        return nil;
    }
}

+(LSOCompositionView *)createLSOCompositionView:(CGSize)fullSize drawpadSize:(CGSize)padSize;
{
    if(padSize.width>0  && padSize.height>0){
        LSOCompositionView  *retView=nil;
        
        if (padSize.width>padSize.height) {  //横屏
            retView=[[LSOCompositionView alloc] initWithFrame:CGRectMake(0, 90, fullSize.width,fullSize.width*(padSize.height/padSize.width))];
        }else{  //竖屏
            //如果高度大于宽度,则使用屏幕的高度一半作为预览界面.同时为了保证预览的画面宽高比一致,等比例得到宽度的值.
            retView=[[LSOCompositionView alloc] initWithFrame:CGRectMake(0,90, fullSize.height*(padSize.width/padSize.height)/2,
                                                                   fullSize.height/2)];
            
            
            retView.center=CGPointMake(fullSize.width/2, retView.center.y);
        }
        return retView;
    }else{
        LSOLog_e(@"createLanSongView ERROR,pad size is error !")
        return nil;
    }
}



+(LSOAeCompositionView *)createAeCompositionView:(CGSize)fullSize drawpadSize:(CGSize)padSize
{
    if(padSize.width>0  && padSize.height>0){
        LSOAeCompositionView  *retView=nil;
        if (padSize.width>padSize.height) {  //横屏
            retView=[[LSOAeCompositionView alloc] initWithFrame:CGRectMake(0, 90, fullSize.width,fullSize.width*(padSize.height/padSize.width))];
        }else{  //竖屏
            //如果高度大于宽度,则使用屏幕的高度一半作为预览界面.同时为了保证预览的画面宽高比一致,等比例得到宽度的值.
            retView=[[LSOAeCompositionView alloc] initWithFrame:CGRectMake(0,90, fullSize.height*(padSize.width/padSize.height)/2,
                                                                   fullSize.height/2)];
            retView.center=CGPointMake(fullSize.width/2, retView.center.y);
        }
        return retView;
    }else{
        LSOLog_e(@"LSOAeCompositionView size is error !")
        return nil;
    }
}


/**
 percent : 如果是竖屏的话, 高度占用全屏的多少大小;
 */
+(LanSongView2 *)createLanSongView:(CGSize)fullSize padSize:(CGSize)size percent:(float)percent
{
    if(size.width>0  && size.height>0){
        LanSongView2  *retView=nil;
        
        if (size.width>size.height) {
            retView=[[LanSongView2 alloc] initWithFrame:CGRectMake(0, 60, fullSize.width,fullSize.width*(size.height/size.width))];
        }else{
            //如果高度大于宽度,则使用屏幕的高度的port大小 作为预览界面.同时为了保证预览的画面宽高比一致,等比例得到宽度的值.
            CGFloat height=fullSize.height*percent;
            CGFloat width=fullSize.height*(size.width/size.height) *percent;
            retView=[[LanSongView2 alloc] initWithFrame:CGRectMake(0, 60, width,height)];
            retView.center=CGPointMake(fullSize.width/2, retView.center.y);
        }
        return retView;
    }else{
        return nil;
    }
}

/**
 设置当前viewController竖屏
 */
+(void)setViewControllerPortrait
{
    [DemoUtils interfaceOrientation:UIInterfaceOrientationPortrait];
}

/**
 设置当前viewController横屏
 */
+(void)setViewControllerLandscape
{
    [DemoUtils interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

/**
 在ViewController中调用, 设置当前屏幕的旋转角度.
 */
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    
    //[self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];  //横屏 home键在左边, 一般不用;
    //    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];  //横屏, home键在右侧, 常见横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



  
  
 



//-------------------print Aejson---------

/**
 打印json中的信息
 */
+(void)printJsonInfo:(LSOAeView *)aeView
{
    LSOLog(@"************************************************************************************")
    LSOLog(@"*\t");
    LSOLog(@"*\t 图片信息(picture info):")
    
    for (LSOAeImageLayer *layer in aeView.imageLayerArray) {
        LSOLog(@"*\t 图片ID::%@,名字:%@,原始宽高:%f x %f. 开始帧:%f,结束帧:%f,时长:%f,帧率:%f",
               layer.imgId,layer.imgName,layer.imgWidth,layer.imgHeight,
               layer.startFrame,layer.endFrame,layer.durationS,layer.jsonFrameRate);
    }
    
    for (LSOAeText *layer in aeView.textInfoArray) {
        LSOLog(@"*\t 文字内容::%@,图层名字:%@,字号:%f. 字体名字:%@,对齐方式:%@;",
               layer.textContents,layer.textlayerName,layer.textFontSize,layer.textFont,
               [DemoUtils convertJustification:layer.textJustification]);
    }
    LSOLog(@"*\t");
    LSOLog(@"************************************************************************************")
}
+(NSString *)convertJustification:(int)justification
{
    if(justification==0){
        return @"左对齐";
    }else if(justification==1){
        return @"右对齐";
    }else if(justification==2){
        return @"居中对齐";
    }else{
        return @"unknow";
    }
}

@end

