//
//  MyCollectionViewCell.m
//  CollectionViewDemo1
//
//  Created by IOS.Mac on 16/10/27.
//  Copyright © 2016年 com.elepphant.pingchuan. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "Masonry.h"

NSString *const kMyCollectionViewCellID = @"kMyCollectionViewCellID";
@interface MyCollectionViewCell()

@property (strong, nonatomic) UIImageView *posterView;


@end




@implementation MyCollectionViewCell

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
