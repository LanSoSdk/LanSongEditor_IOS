//
//  UIPenDemoVC
//  LanSongEditor_all
//
//  Created by sno on 2018/11/12.
//  Copyright © 2018 sno. All rights reserved.
//

#import "UIPenDemoVC.h"

#import "DemoUtils.h"
#import "LSDrawView.h"


#import "StoryMakerFontManager.h"
#import "UIImage+imageWithColor.h"
#import "StoryMakeStickerView.h"
#import "StoryMakeStickerImageView.h"
#import "StoryMakeSelectColorFooterView.h"
#import "StoryMakeStickerLabelView.h"
#import "StoryMakeFilterFooterView.h"
#import "DemoToolButtonsView.h"


@interface UIPenDemoVC ()<LSOToolButtonsViewDelegate, StoryMakeStickerViewDelegate, StoryMakeStickerBaseViewDelegate, StoryMakeSelectColorFooterViewDelegate>
{
    LanSongView2 *lansongView;
    DrawPadVideoPreview *drawpadPreview;
    LSOVideoPen *videoPen;
    LSDrawView *drawView;  //涂鸦;
    LSOViewPen *viewPen;
    UIView *viewPenRoot; //UI图层上的父类UI;
    
    
    LSOVideoOneDo *videoOneDo;
    DemoProgressHUD *hud;
    
}
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *exportBtn;
@property (nonatomic, strong) DemoToolButtonsView *toolsBtnView;
@property (nonatomic, strong) StoryMakeStickerView *stickerFooterView;  //贴纸界面;
@property (nonatomic, strong) StoryMakeSelectColorFooterView *colorFooterView;  //文字

@property (nonatomic, strong) NSMutableArray <UIView *> *stickerViewArray;
@property (nonatomic, assign) NSInteger stickerTags;

@end

@implementation UIPenDemoVC

- (instancetype)init
{
    if (self = [super init]) {
        self.stickerViewArray = [NSMutableArray array];
        self.stickerTags = 0;
    }
    _isRecordDrawPadMode=NO;
    
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor blackColor];
    [super viewDidLoad];
    hud=[[DemoProgressHUD alloc] init];
    
    [self createView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self startDrawPad];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self stopPreview];
}

-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}
- (void)startDrawPad
{
    //创建容器
    
    [self cleaViews];
    
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video];
    
    //增加显示窗口
    [drawpadPreview addLanSongView:lansongView];
    
    //增加UI图层;
    viewPen=[drawpadPreview addViewPen:viewPenRoot isFromUI:YES];
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progress) {
        [weakSelf progressBlock:progress];
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
                NSString *original=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
                //增加上原来的声音;
                NSString *dstPath=[LSOVideoAsset videoMergeAudio:path audio:original];;
                [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
        });
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    //开始执行,并编码
    [drawpadPreview start];
    if(_isRecordDrawPadMode){  //如果是录屏模式,则开启录制.
      [drawpadPreview startRecord];
    }
}
-(void)progressBlock:(CGFloat)progress
{
    
}

/**
 创建view
 */
- (void)createView
{
    CGSize size=self.view.frame.size;
    
    lansongView=[DemoUtils createLanSongView:size padSize:[AppDelegate getInstance].currentEditVideoAsset.videoSize percent:0.9f];
    lansongView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lansongView];
    
    
    viewPenRoot=[[UIView alloc] initWithFrame:lansongView.frame];
    [self.view addSubview:viewPenRoot];
    
    //ui上面增加涂鸦功能.
    drawView=[[LSDrawView alloc] initWithFrame:CGRectMake(0, 0, viewPenRoot.frame.size.width, viewPenRoot.frame.size.height)];
    drawView.brushColor = UIColorFromRGB(255, 255, 0);
    drawView.shapeType = LSShapeCurve;  //形状是曲线;
    [viewPenRoot addSubview:drawView];
    
    
    [self.view addSubview:self.cancelBtn];
    if(!_isRecordDrawPadMode){
          [self.view addSubview:self.exportBtn];
    }else{
        UILabel *label=[[UILabel alloc] init];
        label.text=@"当前是: 录制模式";
        label.textColor=[UIColor whiteColor];
        
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
            make.right.mas_equalTo(self.view.mas_right).offset(- SCREENAPPLYHEIGHT(48));
            make.width.mas_equalTo(SCREENAPPLYHEIGHT(200));
        }];
    }
    
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.left.mas_equalTo(self.view.mas_left).offset(SCREENAPPLYHEIGHT(10));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(48));
    }];
    
    if(!_isRecordDrawPadMode){  //如果不是录屏模式;
        [self.exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
            make.right.mas_equalTo(self.view.mas_right).offset(- SCREENAPPLYHEIGHT(48));
            make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(48));
        }];
    }
    
    // up layer tools
    [self.view addSubview:self.toolsBtnView];
    [self.view addSubview:self.stickerFooterView]; //贴纸弹出
    [self.view addSubview:self.colorFooterView]; //文字提出;
    
    [self.toolsBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(74));
    }];
    
    [self.toolsBtnView configureView:@[@"贴纸",@"暂停",@"文字",@"清除"] btnWidth:50 viewWidth:self.view.frame.size.width];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    BOOL selected = NO;
    
    for (UIView *obj in self.stickerViewArray) {
        if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
            StoryMakeStickerBaseView *view = (StoryMakeStickerBaseView *)obj;
            if (CGRectContainsPoint(view.frame, point) && !selected) {
                view.isSelected = YES;
                selected = YES;
            }else{
                view.isSelected = NO;
            }
        }
    }
}
-(void)LSOToolButtonsSelected:(int)index
{
    switch (index) {
        case 0:  //贴纸
             [self showStickerFooterView];
            break;
        case 1:  //暂停
            if([drawpadPreview isPaused]){
                [drawpadPreview resume];
            }else{
                [drawpadPreview pause];
            }
            break;
        case 2:  //写字
            self.colorFooterView.type = StoryMakeSelectColorFooterViewTypeWriting;
            [self showColorFooterView];
            break;
        case 3:  //清除
            [self cleaViews];
            break;
        default:
            break;
    }
}
//清除贴纸;
-(void)cleaViews
{
    for (int i=0; i<self.stickerViewArray.count; i++) {
        StoryMakeStickerBaseView *view =( StoryMakeStickerBaseView *) [self.stickerViewArray objectAtIndex:i];
        [view removeFromSuperview];
    }
    [self.stickerViewArray removeAllObjects];
}
//贴纸选中后的回调;
- (void)stickerViewDidSelectedImage:(UIImage *)image
{
    StoryMakeStickerImageView *stickerImageView = [[StoryMakeStickerImageView alloc] init];
    stickerImageView.delegate = self;
    stickerImageView.tag = self.stickerTags ++;
    //增加过来的默认放到drawimageView的中间;
    stickerImageView.frame = CGRectMake(0, 0, SCREENAPPLYHEIGHT(128), SCREENAPPLYHEIGHT(128));
    stickerImageView.center = viewPenRoot.center;
    stickerImageView.contentImageView.image = image;
    [viewPenRoot addSubview:stickerImageView];
    [self.stickerViewArray insertObject:stickerImageView atIndex:0];
    [self hideStickerFooterView];
}

- (void)storyMakeStickerBaseViewCloseBtnClicked:(StoryMakeStickerBaseView *)view
{
    if (IsEmpty(view)) {
        return;
    }
    [self.stickerViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[StoryMakeStickerBaseView class]]) {
            StoryMakeStickerBaseView *singleView = (StoryMakeStickerBaseView *)obj;
            if (singleView == view) {
                [singleView removeFromSuperview];
                [self.stickerViewArray removeObjectAtIndex:idx];
                *stop = YES;
            }
        }
    }];
}

#pragma mark -
#pragma mark - StoryMakeSelectColorFooterViewDelegate

- (void)storyMakeSelectColorFooterViewCloseBtnClicked
{
    [self hideColorFooterView];
}

- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
    self.colorFooterView.hidden = YES;
    [self showToolsView];
    
    CGRect rect1 = [text boundingRectWithSize:CGSizeMake(SCREENAPPLYHEIGHT(340), MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    CGRect rect2 = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, SCREENAPPLYHEIGHT(100))
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    if (rect2.size.width > SCREENAPPLYHEIGHT(340)) {
        rect2.size.width = SCREENAPPLYHEIGHT(340);
    }
    
    StoryMakeStickerLabelView *stickeLabelView = [[StoryMakeStickerLabelView alloc] initWithLabelHeight:CGSizeMake(rect2.size.width, rect1.size.height)];
    stickeLabelView.delegate = self;
    stickeLabelView.tag = self.stickerTags ++;
    stickeLabelView.frame = CGRectMake(0, 0, rect2.size.width + SCREENAPPLYHEIGHT(44), rect1.size.height + SCREENAPPLYHEIGHT(34));
    stickeLabelView.center = CGPointMake(SCREENAPPLYHEIGHT(187.5), SCREENAPPLYHEIGHT(180));
    stickeLabelView.contentLabel.text = text;
    stickeLabelView.contentLabel.font = font;
    stickeLabelView.contentLabel.textColor = color;
    
    [viewPenRoot addSubview:stickeLabelView];
    [self.stickerViewArray insertObject:stickeLabelView atIndex:0];
}

- (void)storyMakeSelectColorFooterViewConfirmBtnClicked:(UIImage *)drawImage
{
    self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
    self.colorFooterView.hidden = YES;
    [self showToolsView];
    
    UIImageView *drawImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    drawImageView.image = drawImage;
    [viewPenRoot addSubview:drawImageView];
    [self.stickerViewArray insertObject:drawImageView atIndex:0];
}

- (void)showToolsView
{
    self.toolsBtnView.hidden = NO;
}

- (void)hideToolsView
{
    self.toolsBtnView.hidden = YES;
}

- (void)showStickerFooterView
{
    self.stickerFooterView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.stickerFooterView.center = self.view.center;
                     }];
    
}

- (void)hideStickerFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.stickerFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.stickerFooterView.hidden = YES;
                     }];
}
- (void)showColorFooterView
{
    self.colorFooterView.hidden = NO;
    [self hideToolsView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.colorFooterView.center = self.view.center;
                     } completion:^(BOOL finished) {
                         [self.colorFooterView updateColorFooterViewInMainView];
                     }];
    
}

- (void)hideColorFooterView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.colorFooterView.center = CGPointMake(self.view.center.x, self.view.center.y + SCREENAPPLYHEIGHT(667));
                     } completion:^(BOOL finished) {
                         self.colorFooterView.hidden = YES;
                         [self showToolsView];
                     }];
}

- (DemoToolButtonsView *)toolsBtnView
{
    if (!_toolsBtnView) {
        _toolsBtnView = [[DemoToolButtonsView alloc] init];
        _toolsBtnView.delegate = self;
    }
    return _toolsBtnView;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        _cancelBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _cancelBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _cancelBtn.layer.shadowRadius = 2;
        _cancelBtn.layer.shadowOpacity = 0.3;
        _cancelBtn.tag=100;
        [_cancelBtn addTarget:self action:@selector(cancelExportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)exportBtn {
    if(!_exportBtn) {
        _exportBtn = [[UIButton alloc] init];
        [_exportBtn setTitle:@"导出" forState:UIControlStateNormal];
        _exportBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _exportBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _exportBtn.layer.shadowRadius = 2;
        _exportBtn.layer.shadowOpacity = 0.3;
        _exportBtn.tag=101;
        [_exportBtn addTarget:self action:@selector(cancelExportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportBtn;
}

- (void)cancelExportBtnAction:(UIView *)sender
{
    
    if(sender.tag==100){
        [self.navigationController popViewControllerAnimated:NO];
    }else if(sender.tag==101){
        [self exportExecute];
    }
}

/**
 执行导出
 */
-(void)exportExecute
{
    //我们的方法是增加一层UI来做
    UIGraphicsBeginImageContextWithOptions(viewPenRoot.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [viewPenRoot drawViewHierarchyInRect:viewPenRoot.bounds afterScreenUpdates:NO];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
     [self stopPreview];
    WS(weakSelf)
    videoOneDo=[[LSOVideoOneDo alloc] initWithNSURL:[AppDelegate getInstance].currentEditVideoAsset.videoURL];
    [videoOneDo setOverLayPicture:screenImage];
    
 
    [videoOneDo setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf exportProgress:percent];
        });
    }];
    [videoOneDo setCompletionBlock:^(NSString *video) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf exportCompleted:video];
        });
    }];
    [videoOneDo start];
/**
 导出进度显示
 */
}
-(void)exportProgress:(CGFloat)percent;
{
     [hud showProgress:[NSString stringWithFormat:@"进度:%f",percent]];
}

/**
 导出完成显示
 */
-(void)exportCompleted:(NSString *)videoPath
{
    [hud hide];
    [DemoUtils startVideoPlayerVC:self.navigationController dstPath:videoPath];
}
- (StoryMakeStickerView *)stickerFooterView
{
    if (!_stickerFooterView) {
        _stickerFooterView = [[StoryMakeStickerView alloc] init];
        _stickerFooterView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
        _stickerFooterView.delegate = self;
        _stickerFooterView.hidden = YES;
    }
    return _stickerFooterView;
}

- (StoryMakeSelectColorFooterView *)colorFooterView
{
    if (!_colorFooterView) {
        _colorFooterView = [[StoryMakeSelectColorFooterView alloc] init];
        _colorFooterView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
        _colorFooterView.delegate = self;
        _colorFooterView.hidden = YES;
    }
    return _colorFooterView;
}
-(void)dealloc
{
    [self stopPreview];
    drawpadPreview=nil;
    lansongView=nil;
    NSLog(@"Demo1PenMothedVC VC  dealloc");
}
@end
