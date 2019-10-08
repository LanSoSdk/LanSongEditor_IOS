//
//  LSOObject.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/5/13.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"
#import "LSOFileUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOObject : NSObject

//给当前类做一个标记. TAG;
@property (nonatomic,retain) NSString *lsoTag;

/**
 一个类的序列号.
 */
@property (nonatomic,assign) int serialNumber;


/**
 释放当前类;
 */
-(void)releaseLSO;
@end

NS_ASSUME_NONNULL_END
