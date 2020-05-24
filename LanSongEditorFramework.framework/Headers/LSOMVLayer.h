//
//  LSOMVLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/2.
//  Copyright © 2020 sno. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LSOLayer.h"
#import "LSOVideoAsset.h"
#import "LSOAeAnimation.h"
#import "LSOVideoOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOMVLayer : LSOLayer


/**********************一下为内部使用********************************************************/
- (id)initWithColorURL:(NSURL *)colorUrl maskURL:(NSURL *) maskUrl;

@end
NS_ASSUME_NONNULL_END
