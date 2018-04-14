//
//  LanSongMirrorFilter.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/4/14.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongFilter.h"

@interface LanSongMirrorFilter : LanSongFilter
{
  
}

/**
 是否要 上下镜像. 即把上面的画面,反过来显示到下面;
 
 默认是 左右镜像, 把左边的画面,反过来显示到右边;
 */
@property(readwrite, nonatomic) BOOL isVMirror;

@end
