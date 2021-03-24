//
//  LSOAexCompositionView.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/6/30.
//  Copyright © 2020 sno. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LanSongContext.h"





@interface LSOAexDisplayView : UIView <LanSongInput>









@property(nonatomic, copy) void(^ _Nullable userSelectedTextLayerBlock)(LSOObject * _Nullable layer);






- (void)addOverlayLayerArray:(NSMutableArray *)array;
















@end
