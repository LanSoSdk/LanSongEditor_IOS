//
//  LSOBlockCallback.h
  
//
//  Created by brandon_withrow on 12/15/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LSOValueDelegate.h"

/*!
 @brief A block that is used to change a Color value at keytime, the block is called continuously for a keypath while the aniamtion plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startColor The color from the previous keyframe in relation to the current time.
 @param endColor The color from the next keyframe in relation to the current time.
 @param interpolatedColor The color interpolated at the current time between startColor and endColor. This represents the keypaths current color for the current time.
 @return CGColorRef the color to set the keypath node for the current frame
 */
typedef CGColorRef _Nonnull (^LSOColorValueCallbackBlock)(CGFloat currentFrame,
                                                          CGFloat startKeyFrame,
                                                          CGFloat endKeyFrame,
                                                          CGFloat interpolatedProgress,
                                                          CGColorRef _Nullable startColor,
                                                          CGColorRef _Nullable endColor,
                                                          CGColorRef _Nullable interpolatedColor);

/*!
 @brief A block that is used to change a Number value at keytime, the block is called continuously for a keypath while the aniamtion plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startValue The Number from the previous keyframe in relation to the current time.
 @param endValue The Number from the next keyframe in relation to the current time.
 @param interpolatedValue The Number interpolated at the current time between startValue and endValue. This represents the keypaths current Number for the current time.
 @return CGFloat the number to set the keypath node for the current frame
 */
typedef CGFloat (^LSONumberValueCallbackBlock)(CGFloat currentFrame,
                                               CGFloat startKeyFrame,
                                               CGFloat endKeyFrame,
                                               CGFloat interpolatedProgress,
                                               CGFloat startValue,
                                               CGFloat endValue,
                                               CGFloat interpolatedValue);
/*!
 @brief A block that is used to change a Point value at keytime, the block is called continuously for a keypath while the aniamtion plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startPoint The Point from the previous keyframe in relation to the current time.
 @param endPoint The Point from the next keyframe in relation to the current time.
 @param interpolatedPoint The Point interpolated at the current time between startPoint and endPoint. This represents the keypaths current Point for the current time.
 @return CGPoint the point to set the keypath node for the current frame.
 */
typedef CGPoint (^LSOPointValueCallbackBlock)(CGFloat currentFrame,
                                              CGFloat startKeyFrame,
                                              CGFloat endKeyFrame,
                                              CGFloat interpolatedProgress,
                                              CGPoint startPoint,
                                              CGPoint endPoint,
                                              CGPoint interpolatedPoint);

/*!
 @brief A block that is used to change a Size value at keytime, the block is called continuously for a keypath while the aniamtion plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startSize The Size from the previous keyframe in relation to the current time.
 @param endSize The Size from the next keyframe in relation to the current time.
 @param interpolatedSize The Size interpolated at the current time between startSize and endSize. This represents the keypaths current Size for the current time.
 @return CGSize the size to set the keypath node for the current frame.
 */
typedef CGSize (^LSOSizeValueCallbackBlock)(CGFloat currentFrame,
                                            CGFloat startKeyFrame,
                                            CGFloat endKeyFrame,
                                            CGFloat interpolatedProgress,
                                            CGSize startSize,
                                            CGSize endSize,
                                            CGSize interpolatedSize);

/*!
 @brief A block that is used to change a Path value at keytime, the block is called continuously for a keypath while the aniamtion plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @return UIBezierPath the path to set the keypath node for the current frame.
 */
typedef CGPathRef  _Nonnull (^LSOPathValueCallbackBlock)(CGFloat currentFrame,
                                                         CGFloat startKeyFrame,
                                                         CGFloat endKeyFrame,
                                                         CGFloat interpolatedProgress);

/*!
 @brief LSOColorValueCallback is wrapper around a LSOColorValueCallbackBlock. This block can be used in conjunction with LSOAnimationView setValueDelegate:forKeypath to dynamically change an animation's color keypath at runtime.
 */

@interface LSOColorBlockCallback : NSObject <LSOColorValueDelegate>

+ (instancetype _Nonnull)withBlock:(LSOColorValueCallbackBlock _Nonnull )block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) LSOColorValueCallbackBlock callback;

@end

/*!
 @brief LSONumberValueCallback is wrapper around a LSONumberValueCallbackBlock. This block can be used in conjunction with LSOAnimationView setValueDelegate:forKeypath to dynamically change an animation's number keypath at runtime.
 */

@interface LSONumberBlockCallback : NSObject <LSONumberValueDelegate>

+ (instancetype _Nonnull)withBlock:(LSONumberValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) LSONumberValueCallbackBlock callback;

@end

/*!
 @brief LSOPointValueCallback is wrapper around a LSOPointValueCallbackBlock. This block can be used in conjunction with LSOAnimationView setValueDelegate:forKeypath to dynamically change an animation's point keypath at runtime.
 */

@interface LSOPointBlockCallback : NSObject <LSOPointValueDelegate>

+ (instancetype _Nonnull)withBlock:(LSOPointValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) LSOPointValueCallbackBlock callback;

@end

/*!
 @brief LSOSizeValueCallback is wrapper around a LSOSizeValueCallbackBlock. This block can be used in conjunction with LSOAnimationView setValueDelegate:forKeypath to dynamically change an animation's size keypath at runtime.
 */

@interface LSOSizeBlockCallback : NSObject <LSOSizeValueDelegate>

+ (instancetype _Nonnull)withBlock:(LSOSizeValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) LSOSizeValueCallbackBlock callback;

@end

/*!
 @brief LSOPathValueCallback is wrapper around a LSOPathValueCallbackBlock. This block can be used in conjunction with LSOAnimationView setValueDelegate:forKeypath to dynamically change an animation's path keypath at runtime.
 */

@interface LSOPathBlockCallback : NSObject <LSOPathValueDelegate>

+ (instancetype _Nonnull)withBlock:(LSOPathValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) LSOPathValueCallbackBlock callback;

@end

