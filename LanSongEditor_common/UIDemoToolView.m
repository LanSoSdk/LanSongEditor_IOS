//
//  UIDemoToolView.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/12.
//  Copyright © 2018 sno. All rights reserved.
//

#import "UIDemoToolView.h"



@interface UIDemoToolView ()

@property (nonatomic, strong) UIButton *stickerBtn;
@property (nonatomic, strong) UIButton *drawBtn;
@property (nonatomic, strong) UIButton *writeBtn;
@property (nonatomic, strong) UIButton *fiterBtn;

@end

@implementation UIDemoToolView

- (instancetype)init
{
    if (self = [super init]) {
        [self configureView];
    }
    return self;
}

#pragma mark -
#pragma mark - configure

- (void)configureView
{
    [self addSubview:self.stickerBtn];
    [self.stickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(-SCREENAPPLYHEIGHT(108));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.drawBtn];
    [self.drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(-SCREENAPPLYHEIGHT(36));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.writeBtn];
    [self.writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(SCREENAPPLYHEIGHT(36));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
    [self addSubview:self.fiterBtn];
    [self.fiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self).offset(SCREENAPPLYHEIGHT(108));
        make.height.width.mas_equalTo(SCREENAPPLYHEIGHT(40));
    }];
    
}

#pragma mark -
#pragma mark - Btn Action

- (void)stickerBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerBtnDidSelected)]) {
        [self.delegate stickerBtnDidSelected];
    }
}

- (void)drawBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pauseResumeBtnDidSelected)]) {
        [self.delegate pauseResumeBtnDidSelected];
    }
}

- (void)writeBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(writeBtnDidSelected)]) {
        [self.delegate writeBtnDidSelected];
    }
}

- (void)filterBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearBtnDidSelected)]) {
        [self.delegate clearBtnDidSelected];
    }
}




#pragma mark -
#pragma mark - Getter

- (UIButton *)stickerBtn
{
    if (!_stickerBtn) {
        _stickerBtn = [[UIButton alloc] init];
        [_stickerBtn setTitle:@"贴纸" forState:UIControlStateNormal];
        _stickerBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _stickerBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _stickerBtn.layer.shadowRadius = 2;
        _stickerBtn.layer.shadowOpacity = 0.3;
        [_stickerBtn addTarget:self action:@selector(stickerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stickerBtn;
}

- (UIButton *)drawBtn
{
    if (!_drawBtn) {
        _drawBtn = [[UIButton alloc] init];
        [_drawBtn setTitle:@"暂停" forState:UIControlStateNormal];
        _drawBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _drawBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _drawBtn.layer.shadowRadius = 2;
        _drawBtn.layer.shadowOpacity = 0.3;
        [_drawBtn addTarget:self action:@selector(drawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drawBtn;
}

- (UIButton *)writeBtn
{
    if (!_writeBtn) {
        _writeBtn = [[UIButton alloc] init];
        [_writeBtn setTitle:@"文字" forState:UIControlStateNormal];
        _writeBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _writeBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _writeBtn.layer.shadowRadius = 2;
        _writeBtn.layer.shadowOpacity = 0.3;
        [_writeBtn addTarget:self action:@selector(writeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeBtn;
}

- (UIButton *)fiterBtn
{
    if (!_fiterBtn) {
        _fiterBtn = [[UIButton alloc] init];
        [_fiterBtn setTitle:@"清除" forState:UIControlStateNormal];
        _fiterBtn.layer.shadowColor = UIColorFromRGB(0, 0, 0).CGColor;
        _fiterBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _fiterBtn.layer.shadowRadius = 2;
        _fiterBtn.layer.shadowOpacity = 0.3;
        [_fiterBtn addTarget:self action:@selector(filterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fiterBtn;
}


@end
