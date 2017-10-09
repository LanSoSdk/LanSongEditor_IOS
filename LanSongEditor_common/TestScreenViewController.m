//
//  TestScreenViewController.m
//  LanSongEditor_all
//
//  Created by sno on 2017/9/20.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "TestScreenViewController.h"
#import "LanSongUtils.h"


@interface TestScreenViewController ()

@end

@implementation TestScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"强制旋转角度.");
    
    UIImage *imge=[UIImage imageNamed:@"pic1"];
    UIImageView *view=[[UIImageView alloc] initWithImage:imge];
    
    [self.view addSubview:view];
    
   
    [LanSongUtils setViewControllerLandscape];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 设置当前VC可以旋转的角度.但不一定旋转.

 @return
 */
-(UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
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
