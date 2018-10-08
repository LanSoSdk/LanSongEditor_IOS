//
//  LSOAnimationView_Compat.h
//  Lottie
//
//  Created by Oleksii Pavlovskyi on 2/2/17.
//  Copyright (c) 2017 Airbnb. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias LSOView UIView;

#else

#import <AppKit/AppKit.h>
@compatibility_alias LSOView NSView;

typedef NS_ENUM(NSInteger, LSOViewContentMode) {
    LSOViewContentModeScaleToFill,
    LSOViewContentModeScaleAspectFit,
    LSOViewContentModeScaleAspectFill,
    LSOViewContentModeRedraw,
    LSOViewContentModeCenter,
    LSOViewContentModeTop,
    LSOViewContentModeBottom,
    LSOViewContentModeLeft,
    LSOViewContentModeRight,
    LSOViewContentModeTopLeft,
    LSOViewContentModeTopRight,
    LSOViewContentModeBottomLeft,
    LSOViewContentModeBottomRight,
};

#endif

