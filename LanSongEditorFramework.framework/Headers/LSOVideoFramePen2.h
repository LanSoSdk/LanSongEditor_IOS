//
//  PicturePen.h
//  LanSongEditorFramework
//
//  Created by sno on 19/12/01.
//  Copyright © 2019年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#import "LSOPen.h"
#import "LSOVideoAsset.h"
#import "LSOVideoOption.h"




@interface LSOVideoFramePen2 : LSOPen



/**********************一下为内部使用********************************************************/
- (id)initWithAsset:(LSOVideoAsset *)asset option:(LSOVideoOption *)option drawPadSize:(CGSize)size;
@property (nonatomic,readonly)LSOVideoOption *videoOption;
@property (nonatomic,readonly)LSOVideoAsset *videoAsset;

@end
