//
//  ViewPen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/24.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pen.h"


@interface ViewPen : Pen



/**
 内部使用 inner use
 */
@property BOOL isFromUI;

/**
 内部使用 inner use
 */
- (id)initWithView:(UIView *)inputView drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;



@end
