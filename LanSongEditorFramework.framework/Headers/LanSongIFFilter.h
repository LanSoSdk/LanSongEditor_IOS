//
//  LanSongIFFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/10/26.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "LanSongFilter.h"

#define LanSongSDKImgString(file) [@"LanSongEditorBundle.bundle" stringByAppendingPathComponent:file]
/**
 所有IF开头的滤镜的父类, 只可被内部的IF开头滤镜继承, 外界不可使用.
 所有IF开头的滤镜的父类, 只可被内部的IF开头滤镜继承, 外界不可使用.
 所有IF开头的滤镜的父类, 只可被内部的IF开头滤镜继承, 外界不可使用.
 所有IF开头的滤镜的父类, 只可被内部的IF开头滤镜继承, 外界不可使用.
 */
@interface LanSongIFFilter : LanSongFilter

@property  NSMutableArray *bitmapPathArray;

@end
