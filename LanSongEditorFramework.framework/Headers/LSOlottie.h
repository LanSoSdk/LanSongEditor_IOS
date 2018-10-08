//
//  Lottie.h
//  Pods
//
//  Created by brandon_withrow on 1/27/17.
//
//  Dream Big.

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#ifndef Lottie_h
#define Lottie_h

//! Project version number for Lottie.
FOUNDATION_EXPORT double LottieVersionNumber;

//! Project version string for Lottie.
FOUNDATION_EXPORT const unsigned char LottieVersionString[];

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "LSOAnimationTransitionController.h"
#import "LSOAnimatedSwitch.h"
#import "LSOAnimatedControl.h"
#endif

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "LSOCacheProvider.h"
#endif

#import "LSOAnimationView.h"
#import "LSOAnimationCache.h"
#import "LSOComposition.h"
#import "LSOBlockCallback.h"
#import "LSOInterpolatorCallback.h"
#import "LSOValueCallback.h"
#import "LSOValueDelegate.h"

#endif /* Lottie_h */
