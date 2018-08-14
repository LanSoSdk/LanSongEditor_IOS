//
//  TESTAEPreview.m
//  LanSongEditor_all
//
//  Created by sno on 2018/7/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import "TESTAEPreview.h"
#import "LanSongUtils.h"
@interface TESTAEPreview ()
{
    UIImageView *imageview;
}
@end

@implementation TESTAEPreview
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    
    UIImageView *image2=[[UIImageView alloc] initWithFrame:self.view.frame];
    image2.image=[UIImage imageNamed:@"pic1"];
    [self.view addSubview:image2];
    
    
    imageview=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageview];
    
    [self getMVFrame];
    
}
-(void)getMVFrame
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"biye_mvColor" withExtension:@"mp4"];
        NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"biye_mvMask" withExtension:@"mp4"];
        
        LanSongGetMVFrame *frame=[[LanSongGetMVFrame alloc] initWithURL:colorPath maks:maskPath];
       
        [frame start:5.3];
        UIImage *image=[frame getOneFrame];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageview.image=image;
        });
    });
}

@end
