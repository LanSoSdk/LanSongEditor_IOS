//
//  LSOCacheProvider.h
//  Lottie
//
//  Created by punmy on 2017/7/8.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias LSOImage UIImage;

@protocol LSOImageCache;

#pragma mark - LSOCacheProvider

@interface LSOCacheProvider : NSObject

+ (id<LSOImageCache>)imageCache;
+ (void)setImageCache:(id<LSOImageCache>)cache;

@end

#pragma mark - LSOImageCache

/**
 This protocol represent the interface of a image cache which lottie can use.
 
 */
@protocol LSOImageCache <NSObject>

@required
- (LSOImage *)imageForKey:(NSString *)key;
- (void)setImage:(LSOImage *)image forKey:(NSString *)key;

@end

#endif
