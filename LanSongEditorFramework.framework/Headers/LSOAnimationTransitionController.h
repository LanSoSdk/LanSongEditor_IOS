//
//  LSOAnimationTransitionController.h
  
//
//  Created by Brandon Withrow on 1/18/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LSOAnimationTransitionController : NSObject <UIViewControllerAnimatedTransitioning>

- (nonnull instancetype)initWithAnimationNamed:(nonnull NSString *)animation
                                fromLayerNamed:(nullable NSString *)fromLayer
                                  toLayerNamed:(nullable NSString *)toLayer
                       applyAnimationTransform:(BOOL)applyAnimationTransform;


- (instancetype _Nonnull)initWithAnimationNamed:(NSString *_Nonnull)animation
                                  fromLayerNamed:(NSString *_Nullable)fromLayer
                                    toLayerNamed:(NSString *_Nullable)toLayer
                         applyAnimationTransform:(BOOL)applyAnimationTransform
                                        inBundle:(NSBundle *_Nonnull)bundle;

@end

