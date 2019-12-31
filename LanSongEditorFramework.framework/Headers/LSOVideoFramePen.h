//
//  LSOVideoFramePen.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/28.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LSOPen.h"
#import "LSOVideoOption.h"
#import "LSOVideoAsset.h"



/**
 视频图层.
 
 */
@interface LSOVideoFramePen : LSOPen



//----------------一下方法内部使用-----------------------------
//LSNEW 改动视频选项;
- (id)initWithVideoAsset:(LSOVideoAsset *)videoAsset option:(LSOVideoOption *)option padSize:(CGSize)size preview:(BOOL)preview;

@property (nonatomic,readonly)LSOVideoAsset *videoAsset;

@property (nonatomic,readonly)LSOVideoOption *videoOption;



@end
