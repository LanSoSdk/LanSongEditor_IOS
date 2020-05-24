//
//  LSOViewLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/2.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOLayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSOViewLayer : LSOLayer

/******************一下是内部使用******************************/
- (id)initWithView:(UIView *)inputView;

@end

NS_ASSUME_NONNULL_END
