//
//  LSOImageArrayLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/2.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOImageArrayLayer : LSOLayer





@property(nonatomic,readonly) NSArray<UIImage *> *imageArray;


//---------以下内部使用;-----------
-(id)initWithImageArray:(NSArray<UIImage *> *)imageArray intervalS:(CGFloat)intervalS;



@end

NS_ASSUME_NONNULL_END
