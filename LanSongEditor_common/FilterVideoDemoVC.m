//
//  VideoFilterDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "FilterVideoDemoVC.h"

#import "LanSongUtils.h"
#import "FilterTpyeList.h"
#import "FilterItem.h"
#import "FilterCollectionViewCell.h"


@interface FilterVideoDemoVC ()
{

    NSString *srcPath;
    UISlider *slide;
    NSString *dstPath;
    
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    //当前使用的滤镜
    LanSongFilter *currentFilter;
    
    //举例的滤镜列表.
    NSMutableArray *filterItemArray;
    NSMutableArray *filterArray;
    
    //执行过滤镜后的图片列表.
    NSMutableArray *filterImageArray;
    
    BOOL getThumbnailing;
    
    LanSongView2  *lansongView;
    DrawPadVideoPreview *drawpadPreview;
    DrawPadVideoExecute  *drawpadExecute;
    
    CGSize drawpadSize;
}
@end

@implementation FilterVideoDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filterImageArray =[[NSMutableArray alloc] init];
    filterArray=[[NSMutableArray alloc] init];
    filterItemArray=[[NSMutableArray alloc] init];
    
    self.view.backgroundColor=[UIColor whiteColor];
    srcPath=[AppDelegate getInstance].currentEditVideo;
    /*
     获取缩略图
     */
    [self getThumbnailFilters];
}
/**
 开始前台容器
 */
-(void)startPreview
{
    //创建容器
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:srcPath];
    
    drawpadSize=drawpadPreview.drawpadSize;
    drawpadPreview.videoPen.loopPlay=YES;
    //增加显示窗口
    CGSize size=self.view.frame.size;
    lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
    [self.view addSubview:lansongView];
    [drawpadPreview addLanSongView:lansongView];
    
    [self initView];
    
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=slide;
    filterListVC.filterPen=drawpadPreview.videoPen;
    isSelectFilter=NO;
    
    [drawpadPreview start];
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

        
        NSURL *sampleURL = [LanSongFileUtil filePathToURL:srcPath];
        
        UIImage *image=[VideoEditor getVideoImageimageWithURL:sampleURL];
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
            [self startPreview];
        });
    });
}

/**
 后台处理后, 调用这里
 */
-(void)drawpadCompleted:(NSString *)path
{
    dstPath=path;
    isSelectFilter=NO;
    drawpadExecute=nil;
    [self showIsPlayDialog];
}
/**
 停止drawpad的执行.
 */
-(void)stopDrawpad
{
    isSelectFilter=NO;
    if(drawpadPreview!=nil){
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}

/**
 开始后台容器执行.
 filter 滤镜可以和执行前台预览时的共用同一个对象.
 */
-(void)startExecute:(LanSongFilter *)filter
{
        drawpadExecute=[[DrawPadVideoExecute alloc] initWithPath:srcPath];
        //增加滤镜
        [drawpadExecute.videoPen switchFilter:filter];
    
//        //增加Bitmap
//        UIImage *image=[UIImage imageNamed:@"mm"];
//        [drawpad addBitmapPen:image];
    
    
//        //增加MV图层
//        NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
//        NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
//        [drawpad addMVPen:colorPath withMask:maskPath];
    
    
        __weak typeof(self) weakSelf = self;
        [drawpadExecute setProgressBlock:^(CGFloat progess) {
            dispatch_async(dispatch_get_main_queue(), ^{
               // LSLog(@"即将处理时间(进度)是:%f,百分比是:%f",progess,progess/drawpadExecute.mediaInfo.vDuration);
                weakSelf.labProgress.text=[NSString stringWithFormat:@"   当前进度 %f",progess];
            });
        }];
        [drawpadExecute setCompletionBlock:^(NSString *dstPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf drawpadCompleted:dstPath];
            });
        }];
        [drawpadExecute start];
}
//--------------------一下是ui界面.
-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
    if(!getThumbnailing && drawpadPreview==nil){
        [self startPreview];
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
    dstPath=nil;
    drawpadPreview=nil;
    
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
    
    [LanSongFileUtil deleteFile:dstPath];
    LSLog(@"Demo3PenFilterVC dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    //布局其他界面
-(void)initView
{
    if(_labProgress){  //已经初始化
        return ;
    }
    CGSize size=self.view.frame.size;
    

    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    CGFloat padding=size.height*0.02;
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(lansongView.mas_centerX);
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
        
        if(currentFilter!=nil){  //采用列出来的几种滤镜
            [self startExecute:(LanSongFilter *)currentFilter];
        }else{//采用选中的所有滤镜.
            [self startExecute:(LanSongFilter *)filterListVC.selectedFilter];
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
    
    [collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:kMyCollectionViewCellID];
    
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
        
        [(FilterCollectionViewCell *)cell pushCellWithImage:[filterImageArray objectAtIndex:indexPath.row] name:name];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(drawpadPreview!=nil && drawpadPreview.isRunning)
    {
        filterListVC.selectedFilter=nil;
        if(filterArray.count>indexPath.row){
            currentFilter=[filterArray objectAtIndex:indexPath.row];
        }
        [drawpadPreview.videoPen switchFilter:currentFilter]; //切换滤镜.
    }
}
@end

