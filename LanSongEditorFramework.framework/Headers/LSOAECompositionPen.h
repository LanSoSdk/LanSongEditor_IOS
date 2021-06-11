//
//  LSOAECompositionPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/1/30.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOPen.h"
#import "LSOAeCompositionAsset.h"


NS_ASSUME_NONNULL_BEGIN

@interface LSOAECompositionPen : LSOPen



@property (nonatomic,readonly)LSOAeCompositionAsset *compAsset;

@property (nonatomic,readonly)CGSize aeSize;



//-------------------
-(id)initWithAeCompositionAsset:(LSOAeCompositionAsset *)asset drawPadSize:(CGSize) size;

@end

NS_ASSUME_NONNULL_END
