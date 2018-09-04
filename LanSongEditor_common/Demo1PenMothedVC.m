//
//  VideoPictureRealTimeVC.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/29.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "Demo1PenMothedVC.h"

#import "LanSongUtils.h"
#import "VideoPlayViewController.h"

@interface Demo1PenMothedVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    BitmapPen *bmpPen;
    CGSize drawpadSize;
    VideoPen *videoPen;
    
}
@property (nonatomic,assign) NSString *dstPath;
@end

@implementation Demo1PenMothedVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"展示图层基本方法";
    self.view.backgroundColor=[UIColor whiteColor];

  
    [self startPreview]; //开启预览
    //-------------以下是ui操作-----------------------
     CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(lansongView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    UIView *currslide=  [self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"X坐标:"];
            currslide= [self createSlide:currslide min:0.0f max:1.0f value:0.5f tag:102 labText:@"Y坐标:"];
    currslide= [self createSlide:currslide min:0.0f max:3.0f value:1.0f tag:103 labText:@"缩放:"];
    [self createSlide:currslide min:0.0f max:360.0f value:0 tag:104 labText:@"旋转:"];
}
-(void)startPreview
{
    [self stopPreview];
    
    //创建容器
    NSString *video=[AppDelegate getInstance].currentEditVideo;
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video];
    drawpadSize=drawpadPreview.drawpadSize;
    
    //创建显示窗口
    CGSize size=self.view.frame.size;
    lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
    [self.view addSubview:lansongView];
    [drawpadPreview addLanSongView:lansongView];
    
    
    //增加Bitmap图层
    UIImage *image=[UIImage imageNamed:@"mm"];
    bmpPen=[drawpadPreview addBitmapPen:image];
    
    
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progess) {
        [weakSelf progressBlock];
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
            vce.videoPath=path;
            [weakSelf.navigationController pushViewController:vce animated:NO];
        });
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    

    //开始执行,并编码
    [drawpadPreview start];
}
-(void)progressBlock
{
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}
- (void)slideChanged:(UISlider*)sender
{
    if(bmpPen==nil){
        return ;
    }
    
    CGFloat val=[(UISlider *)sender value];
    
    CGFloat posX=drawpadPreview.drawpadSize.width*val;
    CGFloat posY=drawpadPreview.drawpadSize.height*val;
    
    switch (sender.tag) {
        case 101:  //位置
            bmpPen.positionX=posX;
            break;
        case 102:  //Y坐标
            bmpPen.positionY=posY;
            break;
        case 103:  //scale
            bmpPen.scaleHeight=val;
            bmpPen.scaleWidth=val;
            break;
        case 104:  //rotate;
            bmpPen.rotateDegree=val;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 初始化一个slide
 */
-(UIView *)createSlide:(UIView *)parentView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;

{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    
    UISlider *slidePos=[[UISlider alloc] init];
    
    slidePos.maximumValue=max;
    slidePos.minimumValue=min;
    slidePos.value=value;
    slidePos.continuous = YES;
    slidePos.tag=tag;
    
    [slidePos addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slidePos];
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [slidePos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right);
        make.size.mas_equalTo(CGSizeMake(size.width-80, 15));
    }];
    return labPos;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopPreview];
}

-(void)dealloc
{
     [self stopPreview];
    bmpPen=nil;
    drawpadPreview=nil;
    lansongView=nil;
    NSLog(@"Demo1PenMothedVC VC  dealloc");
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


