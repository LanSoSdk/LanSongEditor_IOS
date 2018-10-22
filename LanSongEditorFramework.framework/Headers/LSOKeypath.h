//
//  LSOKeypath.h
//
//  Created by brandon_withrow on 12/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const kLSOKeypathEnd;

/*!
 @brief LSOKeypath is an object that describes a keypath search for nodes in the animation JSON. LSOKeypath matches views inside of LSOAnimationView to their After Effects counterparts.

 @discussion
 LSOKeypath is used with LSOAnimationView to set animation properties dynamically at runtime, to add or mask subviews, converting geometry, and numerous other functions.

 LSOKeypath can describe a specific object, or can use wildcards for fuzzy matching of objects. Acceptable wildcards are either "*" (star) or "**" (double star). Single star will search a single depth for the next object, double star will search any depth.

 Read More at
 
 EG:
  @"Layer.Shape Group.Stroke 1.Color"
  Represents a specific color node on a specific stroke.

  @"**.Stroke 1.Color"
  Represents the color node for every "Stroke 1" in the animation scene.

 */

@interface LSOKeypath : NSObject

/*!
 @brief Creates a LSOKeypath from a dot separated string, can use wildcards @"*" and fuzzy depth wild cards @"**".

 @discussion LSOKeypath is an object that describes a keypath search for nodes in the animation JSON.

 LSOKeypath is used with LSOAnimationView to set animation properties dynamically at runtime, to add or mask subviews, converting geometry, and numerous other functions.

 LSOKeypath can describe a specific object, or can use wildcards for fuzzy matching of objects. Acceptable wildcards are either "*" (star) or "**" (double star). Single star will search a single depth for the next object, double star will search any depth.

 @param  keypath A dot separated string describing a keypath from the JSON animation. EG @"Layer.Shape Group.Stroke 1.Color"

 @return A new LSOKeypath
 */

+ (nonnull LSOKeypath *)keypathWithString:(nonnull NSString *)keypath;

/*!
 @brief Creates a LSOKeypath from a list of keypath string objects, can use wildcards @"*" and fuzzy depth wild cards @"**".

 @discussion LSOKeypath is an object that describes a keypath search for nodes in the animation JSON.

 LSOKeypath is used with LSOAnimationView to set animation properties dynamically at runtime, to add or mask subviews, converting geometry, and numerous other functions.

 LSOKeypath can describe a specific object, or can use wildcards for fuzzy matching of objects. Acceptable wildcards are either "*" (star) or "**" (double star). Single star will search a single depth for the next object, double star will search any depth.

 @param  firstKey A nil terminated list of strings describing a keypath. EG @"Layer", @"Shape Group", @"Stroke 1", @"Color", nil

 @return A new LSOKeypath
 */

+ (nonnull LSOKeypath *)keypathWithKeys:(nonnull NSString *)firstKey, ...
  NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, readonly, nonnull) NSString *absoluteKeypath;
@property (nonatomic, readonly, nonnull) NSString *currentKey;
@property (nonatomic, readonly, nonnull) NSString *currentKeyPath;

@property (nonatomic, readonly, nonnull) NSDictionary *searchResults;

@property (nonatomic, readonly) BOOL hasFuzzyWildcard;
@property (nonatomic, readonly) BOOL hasWildcard;
@property (nonatomic, readonly) BOOL endOfKeypath;

- (BOOL)pushKey:(nonnull NSString *)key;
- (void)popKey;
- (void)popToRootKey;

- (void)addSearchResultForCurrentPath:(id _Nonnull)result;

@end
