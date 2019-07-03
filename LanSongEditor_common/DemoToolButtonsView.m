//
//  LSOToolButtonsView.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/17.
//  Copyright © 2018 sno. All rights reserved.
//

#import "DemoToolButtonsView.h"


@interface DemoToolButtonsView ()


@end

@implementation DemoToolButtonsView

#pragma mark -
#pragma mark - configure
- (void)configureView:(NSArray *)array btnWidth:(CGFloat)width viewWidth:(CGFloat)viewWidth;
{
    int left=viewWidth-array.count*width;
    if(left>0){
        left/=(array.count+1);  //间隔;
    }else{
        left=0;
    }
    int interval=left;  //间隔;
    
    for (int i=0; i<array.count; i++) {
        NSString *txt=[array objectAtIndex:i];
        UIButton *butten=[self addButton:txt tag:i];
        [self addSubview:butten];
        
        [butten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            
            int offset=interval*(i+1) + (SCREENAPPLYHEIGHT(width))*i;
            
            make.left.mas_equalTo(self.mas_left).offset(offset);
            make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(width));
        }];
    }
}

#pragma mark -
#pragma mark - Btn Action

- (void)stickerBtnAction:(UIView *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LSOToolButtonsSelected:)]) {
        [self.delegate LSOToolButtonsSelected:(int)sender.tag];
    }
}
- (UIButton *)addButton:(NSString *)text tag:(int)tag
{
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font=[UIFont systemFontOfSize:24];
    
    [btn setTitle:text forState:UIControlStateNormal];
    btn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 2);
    btn.layer.shadowRadius = 2;
    btn.layer.shadowOpacity = 0.3;
    btn.tag=tag;
    [btn addTarget:self action:@selector(stickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


//其他增加;
@end
