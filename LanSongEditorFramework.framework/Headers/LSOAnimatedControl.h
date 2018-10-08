//
//  LSOAnimatedControl.h
//  Lottie
//
//  Created by brandon_withrow on 8/25/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSOAnimationView;
@class LSOComposition;

@interface LSOAnimatedControl : UIControl

// This class is a base class that is intended to be subclassed

/**
 * Map a specific animation layer to a control state. 
 * When the state is set all layers will be hidden except the specified layer.
 **/

- (void)setLayerName:(NSString * _Nonnull)layerName forState:(UIControlState)state;

@property (nonatomic, readonly, nonnull) LSOAnimationView *animationView;
@property (nonatomic, nullable) LSOComposition *animationComp;

@end
