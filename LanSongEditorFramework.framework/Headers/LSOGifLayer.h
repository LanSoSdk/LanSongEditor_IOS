//
//  LSOGifLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/2.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOGifLayer : LSOLayer

-(id)initWithGifURL:(NSURL *)gifUrl;

@property(readonly) NSURL *gifURL;

@end

NS_ASSUME_NONNULL_END
