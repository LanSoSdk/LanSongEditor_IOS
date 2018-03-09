//
//  VideoFilterVC.m
//  LanSongEditor_all
//
//  Created by sno on 17/1/1.
//  Copyright © 2017年 lansongtech. All rights reserved.
//

#import "Demo3PenFilterVC.h"
#import "LanSongUtils.h"
#import "FilterTpyeList.h"
#import "FilterItem.h"
#import "MyCollectionViewCell.h"


@interface Demo3PenFilterVC ()
{
    DrawPad *drawPad;
    DrawPadView *filterView;  //预览界面.
    
    UISlider *slide;
    NSString *dstPath;
    NSString *dstTmpPath;
    
    
    EditFileBox *srcFile;
    VideoPen *mVideoPen;
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    CGFloat  drawPadWidth;
    CGFloat  drawPadHeight;
    
    //当前使用的滤镜
    LanSongFilter *currentFilter;
    
    //举例的滤镜列表.
    NSMutableArray *filterItemArray;
    NSMutableArray *filterArray;
    
    //执行过滤镜后的图片列表.
    NSMutableArray *filterImageArray;
    
    BOOL getThumbnailing;
    
    DrawPadVideoExecute  *drawpadVideo;
    
}
@end

@implementation Demo3PenFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filterImageArray =[[NSMutableArray alloc] init];
    filterArray=[[NSMutableArray alloc] init];
    filterItemArray=[[NSMutableArray alloc] init];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //拿到默认路径.
    srcFile=[AppDelegate getInstance].currentEditBox;
    
    dstTmpPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    
   
    drawPadWidth=srcFile.drawpadWidth;
    drawPadHeight=srcFile.drawpadHeight;
    
    [self initView];
    
   
    /*
     获取缩略图
     */
    [self getThumbnailFilters];
    
    //滤镜选择.
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=slide;
    filterListVC.filterPen=mVideoPen;
    isSelectFilter=NO;
}
/**
 开始前台容器
 */
-(void)startPreviewDrawPad
{
    /*
     step1:第一步: 创建一个容器,(主要参数为:容器宽度高度,码率,保存路径)
     */
    int  drawPadBitRate=2000*1000;
    drawPad=[[DrawPadPreview alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstTmpPath];
    
    drawPad.TAG=@"preview";
    [drawPad setDrawPadPreView:filterView];
    
    /*
     step2: 第二步: 增加视频图层. 设置为自动刷新模式;
     */
    [drawPad setUpdateMode:kAutoTimerUpdate autoFps:25];
    
    NSLog(@"当前要处理的视频信息是:");
    [MediaInfo checkFile:srcFile.srcVideoPath];
    
    mVideoPen=[drawPad addVideoPen:srcFile.srcVideoPath filter:nil];
    mVideoPen.loopPlay=YES;
    
    [self addBitmapLayer];
    
    /*
     step3: 第三步:开始执行.
     */
    if([drawPad startDrawPad]==NO)
    {
        NSLog(@"DrawPad容器线程执行失败, 请联系我们!");
    }
}

/**
 获取缩略图滤镜, 在获取完毕后, 播放视频.
 */
-(void)getThumbnailFilters
{
    //----一下应为异步执行,读取图片.
     getThumbnailing=YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        filterItemArray=[FilterItem createDemoFilterArray];  //拿到列举的多个滤镜.
        
        NSURL *sampleUrl=[SDKFileUtil filePathToURL:srcFile.srcVideoPath];
        
        UIImage *image=[VideoEditor getVideoImageimageWithURL:sampleUrl];
        if(image!=nil){
            
            for (FilterItem *item in filterItemArray) {
                [filterArray addObject:item.filter];
            }
            filterImageArray=[BitmapPadExecute getMoreImageFromOneImage:image filterArray:filterArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            getThumbnailing=NO;
            if(filterImageArray.count==0){
                [LanSongUtils showDialog:@"获取视频缩略图失败,请联系我们"];
            }else{
                [_collectionView reloadData];
            }
             [self startPreviewDrawPad];
        });
    });
}

-(void)drawpadCompleted
{
    filterListVC.filterPen=nil;
    isSelectFilter=NO;
    mVideoPen=nil;
    [self showIsPlayDialog];
}
-(void)addBitmapLayer
{
    if(drawPad!=nil){
        UIImage *image=[UIImage imageNamed:@"small"];
        BitmapPen *pen=[drawPad addBitmapPen:image];
        
        //放到右上角.(图层的xy,是中心点的位置)
        pen.positionX=pen.drawPadSize.width-pen.penSize.width/2;
        pen.positionY=pen.penSize.height/2;
//        NSLog(@"增加一个 图片图层...");
    }
}
/**
 停止drawpad的执行.
 */
-(void)stopDrawpad
{
    filterListVC.filterPen=nil;
    isSelectFilter=NO;
    mVideoPen=nil;
    if(drawPad!=nil){
        [drawPad stopDrawPad];
        drawPad=nil;
    }
}

/**
  开始后台容器执行.
 filter 滤镜可以和执行前台预览时的共用同一个对象.
 */
-(void)startExecuteDrawPad:(LanSongFilter *)filter
{
    drawpadVideo=[[DrawPadVideoExecute alloc] initWithPath:srcFile.srcVideoPath
                                        drawpadSize:CGSizeMake(drawPadWidth, drawPadHeight) dstPath:dstPath];
    
    __weak typeof(self) weakSelf = self;
    [drawpadVideo setVideoProgressBlock:^(CGFloat time){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"即将处理时间(进度)是:%f,百分比是:%f",time,time/drawpadVideo.videoInfo.vDuration);
             weakSelf.labProgress.text=[NSString stringWithFormat:@"   当前进度 %f",time];
        });
    }];
    
     [drawpadVideo setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            drawpadVideo=nil;  //完毕后, 等于nil, 释放内存.
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf drawpadCompleted];
            });
        });
    }];
    
    UIImage *image=[UIImage imageNamed:@"small"];
    [drawpadVideo addBitmapPen:image];
    [drawpadVideo start];
}
//--------------------一下是ui界面.
-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
    if(!getThumbnailing && drawPad==nil){
        [self startPreviewDrawPad];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (isSelectFilter==NO) {
        [self stopDrawpad];
    }
}
-(void)dealloc
{
    filterListVC=nil;
    mVideoPen=nil;
    dstPath=nil;
    filterView=nil;
    
    if(filterItemArray!=nil){
        [filterItemArray removeAllObjects];
        filterItemArray=nil;
    }
    if(filterArray!=nil){
        [filterArray removeAllObjects];
        filterArray=nil;
    }
    if(filterImageArray!=nil){
        [filterImageArray removeAllObjects];
        filterImageArray=nil;
    }
    
    [SDKFileUtil deleteFile:dstPath];
    
    [SDKFileUtil deleteFile:dstTmpPath];
    NSLog(@"Demo3PenFilterVC dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initView
{
    CGSize size=self.view.frame.size;
    
    /*
     先布局drawpad的显示view;
     原则是:
     横屏,则横向对其边缘.
     竖屏, 则居中显示上半部分.
     */
    
    CGFloat width=size.width;
    CGFloat height=size.width*(drawPadHeight/drawPadWidth);  //等比例显示
    
    if(srcFile.info.vRotateAngle==90 || srcFile.info.vRotateAngle==270 ||srcFile.info.vHeight>srcFile.info.vWidth){
        height=size.height/2;
        width=height*(drawPadWidth/drawPadHeight);
    }
    
    
    CGFloat x=size.width/2-width/2;
    filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(x, 60, width,height)];
    [self.view addSubview: filterView];
    filterView.tag=333;
    
    
    //布局其他界面
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    CGFloat padding=size.height*0.02;
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    
    
    UIButton *btnFilter=[[UIButton alloc] init];
    [btnFilter setTitle:@"全部滤镜     >>>" forState:UIControlStateNormal];
    [btnFilter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnFilter.backgroundColor=[UIColor whiteColor];
    btnFilter.tag=601;
    [btnFilter addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnFilter];
    [btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labProgress.mas_bottom).offset(padding);
        make.left.mas_equalTo(_labProgress.mas_left);
        make.size.mas_equalTo(CGSizeMake(180, 80));
    }];
    
    //调节.
   slide=[self createSlide:btnFilter min:0.0f max:1.0f value:0.5f tag:101 labText:@"全部滤镜调节 "];
    
   UIBarButtonItem *barItemEdit=[[UIBarButtonItem alloc] initWithTitle:@"后台滤镜" style:UIBarButtonItemStyleDone target:self action:@selector(doButtonClicked:)];
    barItemEdit.tag=602;
    self.navigationItem.rightBarButtonItem = barItemEdit;
    
    UIView *vline=[[UIView alloc] init];
    vline.backgroundColor=[UIColor redColor];
    [self.view addSubview:vline];
    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(slide.mas_bottom).offset(6);
        make.left.mas_equalTo(_labProgress.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 1));
    }];
    
    
    UILabel *labHint=[[UILabel alloc] init];
    labHint.text=@"举例常用滤镜";
       [self.view addSubview:labHint];
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vline.mas_bottom).offset(2);
         make.left.mas_equalTo(_labProgress.mas_left);
        make.size.mas_equalTo(CGSizeMake(180, 80));
    }];
    _collectionView =[self createUICollectionView];
}
                       
-(void)doButtonClicked:(UIView *)sender
{
    if(sender.tag==601)
    {
        isSelectFilter=YES;
        [self.navigationController pushViewController:filterListVC animated:YES];
    }else if(sender.tag==602){  //后台滤镜.
        [self stopDrawpad];  //先停止预览drawpad
        
        if(currentFilter!=nil){  //采用滤镜的几种滤镜
             [self startExecuteDrawPad:(LanSongFilter *)currentFilter];
        }else{//采用选中的所有滤镜.
           [self startExecuteDrawPad:(LanSongFilter *)filterListVC.selectedFilter];
        }
    }
}
-(UICollectionView *)createUICollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(130, 130);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向
    layout.minimumLineSpacing = 2; //间距
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width,130) collectionViewLayout:layout];
    
    
    collectionView.collectionViewLayout=layout;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:kMyCollectionViewCellID];
    
    [self.view addSubview:collectionView];
    return collectionView;
}
/*
 
 滑动 效果调节后的相应
 
 */
- (void)slideChanged:(UISlider*)sender
{
    switch (sender.tag) {
        case 101:  //weizhi
            [filterListVC updateFilterFromSlider:sender];
            break;
        default:
            break;
    }
}
-(void)showIsPlayDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经处理完毕,是否需要预览" delegate:self cancelButtonTitle:@"预览" otherButtonTitles:@"返回", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }else {  //返回
        
    }
}
/**
 初始化一个slide 返回这个UISlider对象
 */
-(UISlider *)createSlide:(UIView *)topView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;
{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    
    UISlider *slideFilter=[[UISlider alloc] init];
    
    slideFilter.maximumValue=max;
    slideFilter.minimumValue=min;
    slideFilter.value=value;
    slideFilter.continuous = YES;
    slideFilter.tag=tag;
    
    [slideFilter addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slideFilter];
    
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [slideFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right).offset(2);
        make.right.mas_equalTo(self.view.mas_right).offset(-padding);
    }];
    return slideFilter;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return filterImageArray.count;
}

//dataSource返回每个cell
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMyCollectionViewCellID forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(filterImageArray.count>=indexPath.row){
        NSString *name=((FilterItem *)[filterItemArray objectAtIndex:indexPath.row]).name;
        
         [(MyCollectionViewCell *)cell pushCellWithImage:[filterImageArray objectAtIndex:indexPath.row] name:name];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(drawPad!=nil && drawPad.isWorking)
    {
        filterListVC.selectedFilter=nil;
        if(filterArray.count>indexPath.row){
            currentFilter=[filterArray objectAtIndex:indexPath.row];
        }
        if(mVideoPen!=nil && drawPad!=nil){
            
            [mVideoPen switchFilter:currentFilter];  //切换滤镜.
        }
    }
}
@end

