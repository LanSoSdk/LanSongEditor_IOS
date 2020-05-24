//
//  LSOAeAnimation.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/12/2.
//  Copyright © 2019 sno. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LSOAnimation.h"
#import "LanSongFilter.h"
#import "LSOAeView.h"


NS_ASSUME_NONNULL_BEGIN


@interface LSOAeAnimation : LSOAnimation


+ (instancetype)animationWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;


-(id)initWithAEJson:(NSString *)jsonPath durationS:(CGFloat)durationS;

//*************************一下为内部使用,外界请勿使用***************************************
-(int)drawAnimation:(CGFloat)padPtsS;
@property (nonatomic, readonly) LSOAeView *aeView;

@end

NS_ASSUME_NONNULL_END


