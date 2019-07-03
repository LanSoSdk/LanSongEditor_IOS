//
//  杭州蓝松科技有限公司
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "DemoPhotoAlbumCell.h"

@implementation DemoPhotoAlbumCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.imageRequestID = PHInvalidImageRequestID;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.imageView.bounds = self.bounds;
}

- (void)prepareForReuse {
    [self cancelImageRequest];
    self.imageView.image = nil;
}

- (void)cancelImageRequest {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        self.imageRequestID = PHInvalidImageRequestID;
    }
}

@end
