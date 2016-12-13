//
//  AVInfo.h
//  SimpleVideoFileFilter
//
//  Created by sno on 16/8/17.
//  Copyright © 2016年 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AVInfo : NSObject

@property(readwrite, nonatomic) int width;

@property(readwrite, nonatomic) int height;

@property(readwrite, nonatomic) CGFloat duration ;

@property(readwrite, nonatomic) float fps ;

@property(readwrite, nonatomic) float bitrate ;

- (id)initWithURL:(NSURL *)url;

- (BOOL)prepare;

@end
