//
//  LSOValueCallback.h
//
//  Created by brandon_withrow on 12/15/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LSOValueDelegate.h"

/*!
 @brief LSOColorValueCallback is a container for a CGColorRef. This container is a LSOColorValueDelegate that always returns the colorValue property to its animation delegate.
 @discussion LSOColorValueCallback is used in conjunction with LSOAnimationView setValueDelegate:forKeypath to set a color value of an animation property.
 */

@interface LSOColorValueCallback : NSObject <LSOColorValueDelegate>

+ (instancetype _Nonnull)withCGColor:(CGColorRef _Nonnull)color NS_SWIFT_NAME(init(color:));

@property (nonatomic, nonnull) CGColorRef colorValue;

@end

/*!
 @brief LSONumberValueCallback is a container for a CGFloat value. This container is a LSONumberValueDelegate that always returns the numberValue property to its animation delegate.
 @discussion LSONumberValueCallback is used in conjunction with LSOAnimationView setValueDelegate:forKeypath to set a number value of an animation property.
 */

@interface LSONumberValueCallback : NSObject <LSONumberValueDelegate>

+ (instancetype _Nonnull)withFloatValue:(CGFloat)numberValue NS_SWIFT_NAME(init(number:));

@property (nonatomic, assign) CGFloat numberValue;

@end

/*!
 @brief LSOPointValueCallback is a container for a CGPoint value. This container is a LSOPointValueDelegate that always returns the pointValue property to its animation delegate.
 @discussion LSOPointValueCallback is used in conjunction with LSOAnimationView setValueDelegate:forKeypath to set a point value of an animation property.
 */

@interface LSOPointValueCallback : NSObject <LSOPointValueDelegate>

+ (instancetype _Nonnull)withPointValue:(CGPoint)pointValue;

@property (nonatomic, assign) CGPoint pointValue;

@end

/*!
 @brief LSOSizeValueCallback is a container for a CGSize value. This container is a LSOSizeValueDelegate that always returns the sizeValue property to its animation delegate.
 @discussion LSOSizeValueCallback is used in conjunction with LSOAnimationView setValueDelegate:forKeypath to set a size value of an animation property.
 */

@interface LSOSizeValueCallback : NSObject <LSOSizeValueDelegate>

+ (instancetype _Nonnull)withPointValue:(CGSize)sizeValue NS_SWIFT_NAME(init(size:));

@property (nonatomic, assign) CGSize sizeValue;

@end

/*!
 @brief LSOPathValueCallback is a container for a CGPathRef value. This container is a LSOPathValueDelegate that always returns the pathValue property to its animation delegate.
 @discussion LSOPathValueCallback is used in conjunction with LSOAnimationView setValueDelegate:forKeypath to set a path value of an animation property.
 */

@interface LSOPathValueCallback : NSObject <LSOPathValueDelegate>

+ (instancetype _Nonnull)withCGPath:(CGPathRef _Nonnull)path NS_SWIFT_NAME(init(path:));

@property (nonatomic, nonnull) CGPathRef pathValue;

@end
