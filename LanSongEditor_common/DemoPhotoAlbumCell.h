//
//  杭州蓝松科技有限公司
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


@interface DemoPhotoAlbumCell : UICollectionViewCell
@property (strong, nonatomic) PHAsset *asset;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *menBanView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;

@property (assign, nonatomic) PHImageRequestID imageRequestID;
@end
