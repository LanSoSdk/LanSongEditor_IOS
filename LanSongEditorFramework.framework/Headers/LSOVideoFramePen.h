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
#import "LSOVideoAsset.h"


/**
 视频图层,
 */
@interface LSOVideoFramePen : LSOPen



//----------------一下方法内部使用-----------------------------

- (id)initWithVideoAsset:(LSOVideoAsset *)asset padSize:(CGSize)size preview:(BOOL)preview;

@property BOOL testSaveFile;
@end
