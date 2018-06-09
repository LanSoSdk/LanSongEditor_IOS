//
//  FilterCollectionViewCell.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "FilterCollectionViewCell.h"

#import "Masonry.h"

NSString *const kMyCollectionViewCellID = @"kMyCollectionViewCellID";
@interface FilterCollectionViewCell()

@property (strong, nonatomic) UIImageView *posterView;


@end




@implementation FilterCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _posterView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_posterView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _posterView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
}

#pragma mark - Public Method

- (void)configureCellWithPostURL:(NSString *)posterURL {
    _posterView.image = [UIImage imageNamed:posterURL];
}

- (void)pushCellWithImage:(UIImage *)img name:(NSString *)name
{
    _posterView.image = img;
}

@end
