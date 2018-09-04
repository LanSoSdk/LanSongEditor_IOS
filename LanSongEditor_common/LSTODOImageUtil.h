//
//  LSTODOImageUtil.h
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSTODOImageUtil : NSObject

+(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size;

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;

@end
