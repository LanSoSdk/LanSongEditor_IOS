//
//  DataPen.h
//  LanSongEditorFramework
//
//  Created by sno on 17/3/9.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LSOPen.h"


@interface LSODataPen : LSOPen


/**
 内部使用.
 */
- (id)initWithWidth:(CGFloat )dataWidth height:(CGFloat)dataHeight drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

@end
