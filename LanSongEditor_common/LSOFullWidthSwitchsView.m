//
//  LSOFullWidthSwitchsView.m
//  LanSongEditor_all
//
//  Created by sno on 2019/3/7.
//  Copyright © 2019 sno. All rights reserved.
//

#import "LSOFullWidthSwitchsView.h"

@interface LSOFullWidthSwitchsView ()
{
    UIView *container;
}
@end

@implementation LSOFullWidthSwitchsView

#pragma mark -
#pragma mark - configure
- (void)configureView:(NSArray *)array width:(CGFloat)width
{
    _uiswitchArray=[[NSMutableArray alloc] init];
    
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
        view=  [self newSwitch:view index:i hint:tex width:width];
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).with.offset(40);
    }];
}

#define kSystemOriginColor [UIColor colorWithRed:0.96f green:0.39f blue:0.26f alpha:1.00f]
#define kSystemBlackColor  [UIColor colorWithRed:0.38f green:0.39f blue:0.40f alpha:1.00f]

-(UIView *)newSwitch:(UIView *)topView index:(int)index hint:(NSString *)hint width:(CGFloat)width
{
    UIView  *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor whiteColor];
    label.text=hint;
    label.textColor=[UIColor redColor];
    
    
    UISwitch *uiswitch=[[UISwitch alloc] init];
    uiswitch.tag=index;
    [_uiswitchArray addObject:uiswitch];
    
    [uiswitch addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [container addSubview:view];
    [container addSubview:label];
    [container addSubview:uiswitch];
    
    CGFloat padding=width*0.05;
    
    if (topView==container) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(width, 50));  //按钮的高度.
        }];
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 50));  //按钮的高度.
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
        }];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width-70, 40));
        make.centerY.mas_equalTo(view.mas_centerY);
         make.left.mas_equalTo(view.mas_left).offset(padding);
    }];
    
    [uiswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.centerY.mas_equalTo(label.mas_centerY);
        make.right.mas_equalTo(container.mas_right);
    }];
    return uiswitch;
}
- (void)valueChanged:(UISwitch *)sender
{
    if(self.delegateObj && [self.delegateObj respondsToSelector:@selector(LSOFullWidthSwitchsViewSelected:isOn:)]){
        [self.delegateObj LSOFullWidthSwitchsViewSelected:(int)sender.tag isOn:sender.isOn];
    }
}
@end
