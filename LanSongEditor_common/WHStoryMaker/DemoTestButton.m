//
//  DemoTestButton.m
//  LanSongEditor_all
//
//  Created by sno on 2019/10/21.
//  Copyright © 2019 sno. All rights reserved.
//

#import "DemoTestButton.h"

@interface DemoTestButton()
{
    void (^backHandler)(void);
}
@end
@implementation DemoTestButton


-(id)initWithHandle:(void (^)(void))handler
{
    self=[super init];
    
    backHandler=handler;
    self.frame=CGRectMake(20, 100, 160, 160);
    [super setTitle:@"测试按钮" forState:UIControlStateNormal];
    [super setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    super.titleLabel.font=[UIFont systemFontOfSize:25];
    [self addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
-(void)createTestButton
{
  
}

- (void)doButtonClicked:(UIView *)sender
{
    
    backHandler();
    
}
@end
