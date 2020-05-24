//
//  UIPenParticleDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/17.
//  Copyright © 2018 sno. All rights reserved.
//

#import "UIPenParticleDemoVC.h"


#import "DemoUtils.h"
#import "UIImage+imageWithColor.h"
#import "DemoToolButtonsView.h"


@interface UIPenParticleDemoVC ()<LSOToolButtonsViewDelegate>
{
    LanSongView2 *lansongView;
    DrawPadVideoPreview *drawpadPreview;
    LSOVideoPen *videoPen;
    LSOViewPen *viewPen;
    UIView *viewPenRoot; //UI图层上的父类UI;
    DemoToolButtonsView *toolsBtnView;
    
    
    
    BOOL isFlameMode; //是否是火花滑动模式；
    CAEmitterLayer *emitterMaoPao;
    CAEmitterLayer *starLayer;
    CAEmitterLayer * fireLayer;
    CAEmitterLayer * smokeLayer;
    CAEmitterLayer * yanHuaLayer;
}
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIButton *cancelBtn;


@end

@implementation UIPenParticleDemoVC

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor blackColor];
    [super viewDidLoad];
    
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
    
    [self removeAllEmitterLayer];
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video];
    [drawpadPreview addLanSongView:lansongView];
    
    
    //增加UI图层;
    viewPen=[drawpadPreview addViewPen:viewPenRoot isFromUI:YES];
    [viewPen setUsedCACoreAnimation:YES];  //<--!!!!注意这里一定要设置。
    
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progress) {
        [weakSelf progressBlock:progress];
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *original=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
            NSString *dstPath=[LSOVideoAsset videoMergeAudio:path audio:original];
            [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
        });
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    //开始执行,并编码
    [drawpadPreview start];
    [drawpadPreview startRecord];
}
-(void)progressBlock:(CGFloat)progress
{
}

- (void)createView
{
    CGSize size=self.view.frame.size;
    
    lansongView=[DemoUtils createLanSongView:size padSize:[AppDelegate getInstance].currentEditVideoAsset.videoSize percent:0.9f];
    lansongView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lansongView];
    
    
    viewPenRoot=[[UIView alloc] initWithFrame:lansongView.frame];
    [self.view addSubview:viewPenRoot];
    [self.view addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_top).offset(SCREENAPPLYHEIGHT(31));
        make.left.mas_equalTo(self.view.mas_left).offset(SCREENAPPLYHEIGHT(10));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(48));
    }];
    
    // up layer tools
    toolsBtnView = [[DemoToolButtonsView alloc] init];
    toolsBtnView.delegate = self;
    
    [self.view addSubview:toolsBtnView];
    
    
    [toolsBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREENAPPLYHEIGHT(74));
    }];
    
    [toolsBtnView configureView:@[@"冒泡",@"星星",@"火焰",@"烟花",@"清除"] btnWidth:60 viewWidth:self.view.frame.size.width];
    
}
-(void)LSOToolButtonsSelected:(int)index
{
    switch (index) {
        case 0:  //冒泡
            [self setupMaoPao];
            break;
        case 1:  //星星
            [self setupStar];
            break;
        case 2:  //火焰
            isFlameMode=YES;
            [DemoUtils showDialog:@"滑动屏幕，游动火焰"];
            break;
        case 3:  //烟花
            [self setupYanHua];
            break;
        case 4:  //清除
            [self removeAllEmitterLayer];
            break;
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(isFlameMode&& smokeLayer==nil){
        [self setupFlame:event];
    }
    if(fireLayer!=nil){
        //调整火焰的点;
        UITouch * touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        fireLayer.emitterPosition=touchPoint;
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //删除火焰.
    if(smokeLayer!=nil){
        [fireLayer removeFromSuperlayer];
        [smokeLayer removeFromSuperlayer];
        smokeLayer=nil;
        fireLayer=nil;
    }
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        _cancelBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _cancelBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _cancelBtn.layer.shadowRadius = 2;
        _cancelBtn.layer.shadowOpacity = 0.3;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (void)cancelBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-----------------------------粒子效果
-(void)setupMaoPao
{
    
    if(emitterMaoPao==nil){
        // 1.创建发射器
        emitterMaoPao= [[CAEmitterLayer alloc]init];
        
        // 2.设置发射器的位置
        emitterMaoPao.emitterPosition = CGPointMake(viewPenRoot.center.x, viewPenRoot.bounds.size.height - 20);
        
        // 3.开启三维效果--可以关闭三维效果看看
        emitterMaoPao.preservesDepth = NO;
        
        // 4.创建粒子, 并且设置粒子相关的属性
        // 4.1.创建粒子Cell
        CAEmitterCell *cell = [[CAEmitterCell alloc]init];
        
        // 4.2.设置粒子速度
        cell.velocity = 150;
        //速度范围波动50到250
        cell.velocityRange = 100;
        
        // 4.3.设置粒子的大小
        //一般我们的粒子大小就是图片大小， 我们一般做个缩放
        //    cell.scale = 1.0;
        
        //粒子大小范围: 0.4 - 1 倍大
        //    cell.scaleRange = 0.3;
        
        // 4.4.设置粒子方向
        //这个是设置经度，就是竖直方向 --具体看我们下面图片讲解
        //这个角度是逆时针的，所以我们的方向要么是 (2/3 π)， 要么是 (-π)
        cell.emissionLongitude = -M_PI_2;
        
        cell.emissionRange = M_PI_2 / 4;
        
        // 4.5.设置粒子的存活时间
        cell.lifetime = 6;
        cell.lifetimeRange = 1.5;
        // 4.6.设置粒子旋转
        cell.spin = M_PI_2;
        cell.spinRange = M_PI_2 / 2;
        // 4.6.设置粒子每秒弹出的个数
        cell.birthRate = 20;
        // 4.7.设置粒子展示的图片 --这个必须要设置为CGImage
        cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"good5_30x30"].CGImage);
        // 5.将粒子设置到发射器中--这个是要放个数组进去
        emitterMaoPao.emitterCells = @[cell];
        // 6.将发射器的layer添加到父layer中
        //    [self.view.layer addSublayer:emitter];
        
        [viewPenRoot.layer addSublayer:emitterMaoPao];
    }
}
- (void)setupFlame:(UIEvent *)event{
    
    // 烟雾
    smokeLayer = [CAEmitterLayer layer];

    [viewPenRoot.layer addSublayer:smokeLayer];  //<!--增加到UI图层
    smokeLayer.renderMode = kCAEmitterLayerAdditive;
    smokeLayer.emitterMode = kCAEmitterLayerPoints;
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    smokeLayer.emitterPosition =touchPoint;
    
    
    // 火花
    fireLayer = [CAEmitterLayer layer];
    [viewPenRoot.layer addSublayer:fireLayer];  //增加到UI图层
    fireLayer.emitterSize = CGSizeMake(100.f, 0);
    fireLayer.emitterMode = kCAEmitterLayerOutline;
    fireLayer.emitterShape = kCAEmitterLayerLine;
    fireLayer.renderMode = kCAEmitterLayerAdditive;
    
    fireLayer.emitterPosition = touchPoint ;
    
    // 配置 - 火花
    CAEmitterCell * fireCell = [CAEmitterCell emitterCell];
    fireCell.name = @"fireCell";
    
    fireCell.birthRate = 450.f;
    fireCell.scaleSpeed = 0.5;
    fireCell.lifetime = 0.9f;
    fireCell.lifetimeRange = 0.315;
    
    fireCell.velocity = -80.f;
    fireCell.velocityRange = 30;
    fireCell.yAcceleration = -200; // 向上
    
    fireCell.emissionLongitude = M_PI;
    fireCell.emissionRange = 1.1;
    
    fireCell.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fireCell.contents = (id)[[UIImage imageNamed:@"fire_white"] CGImage];
    
    // 配置 - 烟雾
    CAEmitterCell * smokeCell = [CAEmitterCell emitterCell];
    smokeCell.name = @"smokeCell";
    
    smokeCell.birthRate = 11.f;
    smokeCell.scale = 0.1;
    smokeCell.scaleSpeed = 0.7;
    smokeCell.lifetime = 3.6;
    
    smokeCell.velocity = -40.f;
    smokeCell.velocityRange = 20;
    smokeCell.yAcceleration = -160; // 向上
    
    smokeCell.emissionLongitude = -M_PI * 0.5;  // 向上
    smokeCell.emissionRange = M_PI * 0.25; // 围绕x轴上方向成90度
    
    smokeCell.spin = 1;
    smokeCell.spinRange = 6;
    
    smokeCell.alphaSpeed = -0.12;
    smokeCell.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.27] CGColor];
    smokeCell.contents = (id)[[UIImage imageNamed:@"smoke_white"] CGImage];
    
    // 添加动画
    smokeLayer.emitterCells = @[smokeCell];
    fireLayer.emitterCells = @[fireCell];
}
/**
 * 设置火花的数量, 就是火苗大一些, 或者小一些;
 * ration: 比例系数 0 到 1之间
 举例是:
 UITouch * touch = [[event allTouches] anyObject];
 CGPoint touchPoint = [touch locationInView:self.view];
 
 // 计算比例
 //    CGFloat distanceToBottom = self.view.bounds.size.height - touchPoint.y;
 //    CGFloat per = distanceToBottom / self.view.bounds.size.height;
 //    [self setFireAndSmokeCount:2 * per];
 */
- (void)setFireAndSmokeCount:(float)ratio{
    
    // 火花
    [fireLayer setValue:@(ratio * 500.0) forKeyPath:@"emitterCells.fireCell.birthRate"]; // 产生数量
    [fireLayer setValue:[NSNumber numberWithFloat:ratio] forKeyPath:@"emitterCells.fireCell.lifetime"]; // 生命周期
    [fireLayer setValue:@(ratio * 0.35) forKeyPath:@"emitterCells.fireCell.lifetimeRange"]; // 生命周期变化范围
    [fireLayer setValue:[NSValue valueWithCGPoint:CGPointMake(ratio * 50, 0)] forKeyPath:@"emitterSize"]; // 发射源大小
    // 烟雾
    [smokeLayer setValue:@(ratio * 4) forKeyPath:@"emitterCells.smokeCell.lifetime"]; // 生命周期
    [smokeLayer setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:ratio * 0.3] CGColor] forKeyPath:@"emitterCells.smokeCell.color"]; // 透明度
    
}

/**
 烟花
 */
- (void)setupYanHua{
    // 配置layer
    if(yanHuaLayer!=nil){
        return;
    }
    CAEmitterLayer * fireworksLayer = [CAEmitterLayer layer];
    [viewPenRoot.layer addSublayer:fireworksLayer];
    yanHuaLayer = fireworksLayer;
    
    fireworksLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width * 0.5, self.view.layer.bounds.size.height); // 在底部
    fireworksLayer.emitterSize = CGSizeMake(self.view.layer.bounds.size.width * 0.1, 0.f);  // 宽度为一半
    fireworksLayer.emitterMode = kCAEmitterLayerOutline;
    fireworksLayer.emitterShape = kCAEmitterLayerLine;
    fireworksLayer.renderMode = kCAEmitterLayerAdditive;
    
    // 发射
    CAEmitterCell * shootCell = [CAEmitterCell emitterCell];
    shootCell.name = @"shootCell";
    
    shootCell.birthRate = 1.f;
    shootCell.lifetime = 1.02;  // 上一个销毁了下一个再发出来
    
    shootCell.velocity = 600.f;
    shootCell.velocityRange = 100.f;
    shootCell.yAcceleration = 75.f;  // 模拟重力影响
    
    shootCell.emissionRange = M_PI * 0.25; //
    
    shootCell.scale = 0.05;
    shootCell.color = [[UIColor redColor] CGColor];
    shootCell.greenRange = 1.f;
    shootCell.redRange = 1.f;
    shootCell.blueRange = 1.f;
    shootCell.contents = (id)[[UIImage imageNamed:@"shoot_white"] CGImage];
    
    shootCell.spinRange = M_PI;  // 自转360度
    
    // 爆炸
    CAEmitterCell * explodeCell = [CAEmitterCell emitterCell];
    explodeCell.name = @"explodeCell";
    
    explodeCell.birthRate = 1.f;
    explodeCell.lifetime = 0.5f;
    explodeCell.velocity = 0.f;
    explodeCell.scale = 2.5;
    explodeCell.redSpeed = -1.5;  //爆炸的时候变化颜色
    explodeCell.blueRange = 1.5; //爆炸的时候变化颜色
    explodeCell.greenRange = 1.f; //爆炸的时候变化颜色
    
    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";
    
    sparkCell.birthRate = 400.f;
    sparkCell.lifetime = 3.f;
    sparkCell.velocity = 125.f;
    sparkCell.yAcceleration = 75.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度
    
    sparkCell.scale = 2.5f;  //调整爆炸的大小；
    sparkCell.contents = (id)[[UIImage imageNamed:@"star_white_stroke"] CGImage];
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;
    
    sparkCell.spin = M_PI * 2; // 自转
    
    //添加动画
    fireworksLayer.emitterCells = @[shootCell];
    shootCell.emitterCells = @[explodeCell];
    explodeCell.emitterCells = @[sparkCell];
}
-(void)setupStar
{
    if(starLayer!=nil){
        return;
    }
    starLayer = [[CAEmitterLayer alloc]init];
    [viewPenRoot.layer addSublayer:starLayer];
    
    starLayer.emitterPosition = viewPenRoot.center;
    //设置粒子发送器每秒钟发送粒子数量
    starLayer.birthRate = 2;
    //设置粒子发送器的样式
    starLayer.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)[UIImage imageNamed:@"star_emitter"].CGImage;
    CAEmitterCell *cell2 = [CAEmitterCell emitterCell];
    cell2.contents = (id)[UIImage imageNamed:@"point_emitter"].CGImage;
    CAEmitterCell *cell1 = [CAEmitterCell emitterCell];
    cell1.contents = (id)[UIImage imageNamed:@"star_emitter"].CGImage;
    cell1.birthRate = 1;
    cell1.lifetime = 3;
    cell1.lifetimeRange = 2;
    cell1.velocity = 30;
    cell1.velocityRange = 20;
    cell1.emissionLongitude = 180*M_PI;
    cell1.yAcceleration = 100;
    cell1.emissionRange = 180*M_PI/180;
    
    //    粒子的出生量
    cell.birthRate = 2;
    //    存活时间
    cell.lifetime = 3;
    cell.lifetimeRange = 1;
    //    设置粒子发送速度
    cell.velocity = 50;
    cell.velocityRange = 30;
    //    粒子发送的方向
    cell.emissionLatitude = 90*M_PI/180;
    //    发送粒子的加速度
    cell.yAcceleration = -100;
    
    //    散发粒子的范围  ->  弧度
    cell.emissionRange = 180*M_PI/180;
    
    
    
    //    粒子的出生量
    cell2.birthRate = 4;
    //    存活时间
    cell2.lifetime = 3;
    cell2.lifetimeRange = 1;
    //    设置粒子发送速度
    cell2.velocity = 80;
    cell2.velocityRange = 50;
    //    粒子发送的方向
    cell2.emissionLatitude = 90*M_PI/180;
    //    发送粒子的加速度
    cell2.yAcceleration = -100;
    
    //    散发粒子的范围  ->  弧度
    cell2.emissionRange = 180*M_PI/180;
    
    //把粒子的cell添加到粒子发送器
    starLayer.emitterCells = @[cell,cell1,cell2];
}
/**
 清除所有的粒子发射器;
 */
-(void)removeAllEmitterLayer{
    
        isFlameMode=NO;
    if(starLayer!=nil){
        [starLayer removeFromSuperlayer];
        starLayer=nil;
    }
    
    if(emitterMaoPao!=nil){
        [emitterMaoPao removeFromSuperlayer];
        emitterMaoPao=nil;
    }
    if(fireLayer!=nil){
        [fireLayer removeFromSuperlayer];
        fireLayer=nil;
    }
    if(smokeLayer!=nil){
        [smokeLayer removeFromSuperlayer];
        smokeLayer=nil;
    }
    if(yanHuaLayer!=nil){
        [yanHuaLayer removeFromSuperlayer];
        yanHuaLayer=nil;
    }
}

-(void)dealloc
{
    [self stopPreview];
    drawpadPreview=nil;
    lansongView=nil;
    NSLog(@"Demo1PenMothedVC VC  dealloc");
}
@end
