//
//  DrawPadVideo.h
//  SimpleVideoFileFilter
//
//  Created by sno on 16/8/17.
//  Copyright © 2016年 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawPad.h"


/**
 继承自DrawPad, 是用在 [前台]  处理的容器;
 内部不含UIView, 需要外部增加,我们demo有举例;
 */
@interface DrawPadPreview : DrawPad

@end
