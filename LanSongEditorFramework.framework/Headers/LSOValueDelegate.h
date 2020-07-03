//
//  LSOValueDelegate.h
  
//
//  Created by brandon_withrow on 1/5/18.
//  Copyright © 2018 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>



@protocol LSOValueDelegate <NSObject>

@end

@protocol LSOColorValueDelegate <LSOValueDelegate>
@required

- (CGColorRef)colorForFrame:(CGFloat)currentFrame
              startKeyframe:(CGFloat)startKeyframe
                endKeyframe:(CGFloat)endKeyframe
       interpolatedProgress:(CGFloat)interpolatedProgress
                 startColor:(CGColorRef)startColor
                   endColor:(CGColorRef)endColor
               currentColor:(CGColorRef)interpolatedColor;


@end

@protocol LSONumberValueDelegate <LSOValueDelegate>
@required

- (CGFloat)floatValueForFrame:(CGFloat)currentFrame
                startKeyframe:(CGFloat)startKeyframe
                  endKeyframe:(CGFloat)endKeyframe
         interpolatedProgress:(CGFloat)interpolatedProgress
                   startValue:(CGFloat)startValue
                     endValue:(CGFloat)endValue
                 currentValue:(CGFloat)interpolatedValue;

@end

@protocol LSOPointValueDelegate <LSOValueDelegate>
@required


- (CGPoint)pointForFrame:(CGFloat)currentFrame
           startKeyframe:(CGFloat)startKeyframe
             endKeyframe:(CGFloat)endKeyframe
    interpolatedProgress:(CGFloat)interpolatedProgress
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
            currentPoint:(CGPoint)interpolatedPoint;

@end

@protocol LSOSizeValueDelegate <LSOValueDelegate>
@required

- (CGSize)sizeForFrame:(CGFloat)currentFrame
         startKeyframe:(CGFloat)startKeyframe
           endKeyframe:(CGFloat)endKeyframe
  interpolatedProgress:(CGFloat)interpolatedProgress
             startSize:(CGSize)startSize
               endSize:(CGSize)endSize
           currentSize:(CGSize)interpolatedSize;


@end

@protocol LSOPathValueDelegate <LSOValueDelegate>
@required

- (CGPathRef)pathForFrame:(CGFloat)currentFrame
            startKeyframe:(CGFloat)startKeyframe
              endKeyframe:(CGFloat)endKeyframe
     interpolatedProgress:(CGFloat)interpolatedProgress;


@end
