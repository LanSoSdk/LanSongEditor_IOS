//
//  LanSongVideoParam.h
//  LanSongEditor_all
//
//  Created by sno on 2018/11/1.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanSongVideoParam : NSObject

-(id)initWithPath:(NSString *)path;

-(id)initWithURL:(NSURL *)url;

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSString *videoPath;
@property (nonatomic,assign) CGSize videoSize;

@end

NS_ASSUME_NONNULL_END
