//
//  LSOFullWidthButtonsView.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "DemoFullWidthButtonsView.h"


@interface DemoFullWidthButtonsView ()
{
    UIView *container;
}
@end

@implementation DemoFullWidthButtonsView

#pragma mark -
#pragma mark - configure
- (void)configureView:(NSArray *)array width:(CGFloat)width
{
    self.backgroundColor=[UIColor lightGrayColor];
    container = [UIView new];
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    UIView *view=container;
    for (int i=0; i<array.count; i++) {
        NSString *tex=[array objectAtIndex:i];
        view=  [self newButton:view index:i hint:tex width:width];
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).with.offset(40);
    }];
}

- (void)buttonClick:(UIView *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LSOFullWidthButtonsViewSelected:)]) {
        [self.delegate LSOFullWidthButtonsViewSelected:(int)sender.tag];
    }
}
#define kSystemOriginColor [UIColor colorWithRed:0.96f green:0.39f blue:0.26f alpha:1.00f]
#define kSystemBlackColor  [UIColor colorWithRed:0.38f green:0.39f blue:0.40f alpha:1.00f]


-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint width:(CGFloat)width
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn addTarget:self action:@selector(buttonDownClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.showsTouchWhenHighlighted = YES;
    
    [container addSubview:btn];
    
     CGFloat padding=width*0.05;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(width, 50));  //按钮的高度.
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(width, 50));
        }];
    }
    
    return btn;
}
@end
