//
//  UIView+UIImage.m
//  TouchPainter
//
//  Created by Carlo Chung on 10/23/10.
//  Copyright 2010 Carlo Chung. All rights reserved.
//

#import "UIView+UIImage.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation UIView (UIImage)

- (UIImage*) ScreenShots
{
    @synchronized(self)
    {
        CGSize imageSize = CGSizeMake(1024, 748);
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        else
            UIGraphicsBeginImageContext(imageSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        // Iterate over every window from back to front
        for (UIWindow *window  in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the BlazeiceScreenAndAudioRecord space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                if ([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UIWindow"]||([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&!window.opaque)) {
                    NSMutableString * string = [[NSMutableString alloc] initWithCapacity:10];
                    if ([window.subviews count] > 1) {
                        UIView *keyboard = [window.subviews objectAtIndex:0];
                        [string setString:[NSString stringWithFormat:@"%@",[keyboard class]]];
                    }
                    if ([string isEqualToString:@"UIPeripheralHostView"]) {
                        CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                        // Offset by the portion of the bounds left of and above the anchor point
                        CGContextTranslateCTM(context,
                                                -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                                -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                    }
                    else
                    {
                        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
      
                        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y - 20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x);
                        }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || UIInterfaceOrientationPortrait) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(-M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y + 256+20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x + 256);
                        }
                    }
                }
                else if([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&window.opaque)
                {
                    CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                    // Offset by the portion of the bounds left of and above the anchor point
                    CGContextTranslateCTM(context,
                                            -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                            -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                }
                // Code, such as a loop that creates a large number of temporary objects.
                // Render the layer hierarchy to the current context|
                [[window layer] renderInContext:context];//呈现接受者及其子范围到指定的上下文
                CGContextRestoreGState(context);
                window.layer.contents = nil;
            }
        }
        // Retrieve the screenshot image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRunCourseWeb" object:@"1"];
        
        return image;
    }
}


- (UIImage*)ScreenShots2
{
    @synchronized(self)
    {
        CGSize imageSize = CGSizeMake(1024, 748);//[self bounds].size;// [[UIScreen mainScreen] bounds].size;
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        else
            UIGraphicsBeginImageContext(imageSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        // Iterate over every window from back to front
        for (UIWindow *window  in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the BlazeiceScreenAndAudioRecord space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                if ([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UIWindow"]) {
                    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                        // Apply the window's transform about the anchor point
                        CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
                        // Offset by the portion of the bounds left of and above the anchor point
                        CGContextTranslateCTM(context,
                                              -[window bounds].size.height * [[window layer] anchorPoint].y - 20,
                                              -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x);
                    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || UIInterfaceOrientationPortrait) {
                        // Apply the window's transform about the anchor point
                        CGContextConcatCTM(context, CGAffineTransformMakeRotation(-M_PI_2));
                        // Offset by the portion of the bounds left of and above the anchor point
                        CGContextTranslateCTM(context,
                                              -[window bounds].size.height * [[window layer] anchorPoint].y + 256+20,
                                              -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x + 256);
                    }

                }
                else if([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"])
                {
                    CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                    // Offset by the portion of the bounds left of and above the anchor point
                    CGContextTranslateCTM(context,
                                          -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                          -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                }
                // Code, such as a loop that creates a large number of temporary objects.
                // Render the layer hierarchy to the current context|
                [[window layer] renderInContext:context];//呈现接受者及其子范围到指定的上下文
                CGContextRestoreGState(context);
                window.layer.contents = nil;
            }
        }
        // Retrieve the screenshot image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRunCourseWeb" object:@"1"];
        
        return image;
    }
}

- (UIImage*)ScreenShots3
{
    @synchronized(self)
    {
        CGSize imageSize = CGSizeMake(1024, 748);//[self bounds].size;// [[UIScreen mainScreen] bounds].size;
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        else
            UIGraphicsBeginImageContext(imageSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        // Iterate over every window from back to front
        for (UIWindow *window  in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the BlazeiceScreenAndAudioRecord space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                if ([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UIWindow"]||([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&!window.opaque)) {
                    NSMutableString * string = [[NSMutableString alloc] initWithCapacity:10];
                    if ([window.subviews count] > 1) {
                        UIView *keyboard = [window.subviews objectAtIndex:0];
                        [string setString:[NSString stringWithFormat:@"%@",[keyboard class]]];
                    }
                    if ([string isEqualToString:@"UIPeripheralHostView"]) {
                        
                        CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                        // Offset by the portion of the bounds left of and above the anchor point
                        CGContextTranslateCTM(context,
                                              -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                              -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                    }
                    
                    else
                    {
                        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y - 20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x);
                        }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight|| UIInterfaceOrientationPortrait) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(-M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y + 256+20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x + 256);
                        }
                    }
                }
                else if([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&window.opaque)
                {
                    CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                    // Offset by the portion of the bounds left of and above the anchor point
                    CGContextTranslateCTM(context,
                                          -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                          -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                    
                }
                // Code, such as a loop that creates a large number of temporary objects.
                // Render the layer hierarchy to the current context|

                [[window layer] renderInContext:context];//呈现接受者及其子范围到指定的上下文
                CGContextRestoreGState(context);
                window.layer.contents = nil;
            }
        }
        // Retrieve the screenshot image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRunCourseWeb" object:@"1"];
        
        return image;
    }
}

- (UIImage*)ScreenShotsOnece
{
    CGSize imageSize = CGSizeMake(1024, 748);//[self bounds].size;// [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    else
        UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)) {
        for (UIWindow *window  in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the BlazeiceScreenAndAudioRecord space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                if ([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UIWindow"]||([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&!window.opaque)) {
                    NSMutableString * string = [[NSMutableString alloc] initWithCapacity:10];
                    if ([window.subviews count] > 1) {
                        UIView *keyboard = [window.subviews objectAtIndex:0];
                        [string setString:[NSString stringWithFormat:@"%@",[keyboard class]]];
                    }
                    if ([string isEqualToString:@"UIPeripheralHostView"]) {
                        CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                        // Offset by the portion of the bounds left of and above the anchor point
                        CGContextTranslateCTM(context,
                                              -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                              -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                    }
                    else
                    {
                        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                        
                        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y - 20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x);
                        }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || UIInterfaceOrientationPortrait) {
                            // Apply the window's transform about the anchor point
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(-M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y + 256+20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x + 256);
                        }
                    }
                }
                else if([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"]&&window.opaque)
                {
                    CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                    // Offset by the portion of the bounds left of and above the anchor point
                    CGContextTranslateCTM(context,
                                          -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                          -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                }
                // Code, such as a loop that creates a large number of temporary objects.
                // Render the layer hierarchy to the current context|
                [[window layer] renderInContext:context];//呈现接受者及其子范围到指定的上下文
                CGContextRestoreGState(context);
                window.layer.contents = nil;
            }
        }
    }
    else{
        for (UIWindow *window  in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the BlazeiceScreenAndAudioRecord space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                if ([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UIWindow"]) {
                    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                        // Apply the window's transform about the anchor point
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
                            CGContextTranslateCTM(context,-512+[[window layer] anchorPoint].y,-384-20+[[window layer] anchorPoint].x);
                        }
                        else{
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y - 20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x);
                        }
                    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || UIInterfaceOrientationPortrait) {
                        // Apply the window's transform about the anchor point
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
                            CGContextTranslateCTM(context,-512+[[window layer] anchorPoint].y,-384-20+[[window layer] anchorPoint].x);
                        }
                        else{
                            CGContextConcatCTM(context, CGAffineTransformMakeRotation(-M_PI_2));
                            // Offset by the portion of the bounds left of and above the anchor point
                            CGContextTranslateCTM(context,
                                                  -[window bounds].size.height * [[window layer] anchorPoint].y + 256+20,
                                                  -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x + 256);
                        }
                    }
                }
                else if([[NSString stringWithFormat:@"%@",[window class]] isEqualToString:@"UITextEffectsWindow"])
                {
                    CGContextConcatCTM(context, CGAffineTransformMakeRotation(2*M_PI));
                    // Offset by the portion of the bounds left of and above the anchor point
                    CGContextTranslateCTM(context,
                                          -[window bounds].size.height * [[window layer] anchorPoint].y-130,
                                          -([window bounds].size.height/2+[window bounds].size.width) * [[window layer] anchorPoint].x+300);
                }
                // Code, such as a loop that creates a large number of temporary objects.
                // Render the layer hierarchy to the current context|
                [[window layer] renderInContext:context];//呈现接受者及其子范围到指定的上下文
                CGContextRestoreGState(context);
                window.layer.contents = nil;
            }
        }
    }
    // Iterate over every window from back to front
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//图片缩放处理 等比例
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    if (image.size.width > 90 && image.size.height >100) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    }else if(image.size.width > 90 && image.size.height < 100){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height)];
    }else if(image.size.width < 90 && image.size.height > 100){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width,image.size.height));
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage*)captureView: (UIView *)theView
{
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (CGSize) adaptiveImageWithImage:(UIImage *)image width:(float)w height:(float)h
{
    float width = image.size.width;
    float height = image.size.height;
    if (width > w) {
        height = height * w/width;
        width = w;
        if (height > h) {
            width = width * h/height;
            height = h;
        }
    }
    else {
        if (height > h) {
            height = h;
            width = width*h/height;
        }
        else {
            width = image.size.width;
            height = image.size.height;
        }
    }
    return CGSizeMake(width, height);
}
////
- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;
    
    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8, //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 kCGImageAlphaNoneSkipFirst//CGImageGetBitmapInfo(source)
                                                 );
    
    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);
    
    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    return resultRef;
}
- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];
    
    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context,  [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
    
    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width/cropSize.width,
                                                            outputSize.height/cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height/2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);
    
    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       ,source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

@end
