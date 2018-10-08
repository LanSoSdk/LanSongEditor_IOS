//
//  CeshiVC.m
//  LanSongEditor_DEMO
//
//  Created by dwj on 2018/9/10.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "CeshiVC.h"
#import <LanSongEditorFramework/LanSongEditor.h>

@interface CeshiVC (){
    LanSongExtractFrame *ex;
}
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation CeshiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testFile];
}


-(void)testFile
{
    self.imgArr = [NSMutableArray arrayWithCapacity:1];
    self.imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imgView];
    
    NSString *defaultVideo=@"dy_xialu1";
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
    sampleURL = [[NSBundle mainBundle] URLForResource:@"hongsan_mvColor" withExtension:@"mp4"];
    if(sampleURL!=nil){
//        labPath.text=[NSString stringWithFormat:@"使用默认视频:%@",defaultVideo];
//        [AppDelegate getInstance].currentEditVideo=[LanSongFileUtil urlToFileString:sampleURL];
    }
    ex=[[LanSongExtractFrame alloc] initWithPath:[LanSongFileUtil urlToFileString:sampleURL]];
    [ex setExtractProcessBlock:^(UIImage *img, CMTime ptsS) {
//        NSLog(@"save to :%@",[LanSongFileUtil saveUIImage:img]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_imgArr addObject:img];
//            self.imgView.image = img;
        });
    }];
    
    [ex setExtractCompletedBlock:^(LanSongExtractFrame *v) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imgView removeFromSuperview];
            UIScrollView *scro = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
            [self.view addSubview:scro];
            
            for (int i = 0; i < _imgArr.count; i++) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i * 100 * 9 / 16, 0, 50, 100)];
                [scro addSubview:img];
                UIImage *image = [_imgArr objectAtIndex:(i)];
                img.image = image;
            }
            scro.contentSize = CGSizeMake(100 * 9 / 16 * 50, 0);
        });
    }];
    [ex start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
