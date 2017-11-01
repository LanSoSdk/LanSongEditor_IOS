//
//  BitmapPadVC.m
//  LanSongEditor_all
//
//  Created by sno on 2017/9/15.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "BitmapPadVC.h"
#import "LanSongUtils.h"



/**
 2017年09月15日10:53:48 
 测试OK;
 
 */
@interface BitmapPadVC ()
{
    UIImage *inputImage;
    LanSongPicture *picture;
    LanSongView  *imageView;
    LanSongFilterPipeline *pipeline;
}
@end

@implementation BitmapPadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 图片输入源
    inputImage = [UIImage imageNamed:@"dayu"];
    
    // 初始化 picture
    picture    = [[LanSongPicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    
    // 初始化 imageView
    imageView  = [[LanSongView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    // 使用 GPUImageFilterPipeline 添加组合滤镜
    LanSongRGBFilter  *filter1 = [[LanSongRGBFilter alloc] init];
    LanSongToonFilter *filter2 = [[LanSongToonFilter alloc] init];
    
    NSMutableArray *arrayTemp = [NSMutableArray array];
    [arrayTemp addObject:filter2];
    [arrayTemp addObject:filter1];
  
    pipeline = [[LanSongFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:picture output:imageView];
    
    // 处理图片
    [picture processImage];
    [filter1 useNextFrameForImageCapture]; // 这个filter 可以是filter1 filter2等
    
    // 输出处理后的图片
    UIImage  *outputImage = [pipeline currentFilteredFrame];
    
    // 保存到系统相册
    UIImageWriteToSavedPhotosAlbum(outputImage, self, nil, nil);
    
}
//-(UIImage *)getFilterImage:(UIImage *)srcImage filters:(LanSongFilter *)filter
//{
//    //TODO 暂时没有整理上面的.
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
