//
//  LSOAeModule.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOAexImage.h"


NS_ASSUME_NONNULL_BEGIN

@interface LSOAexModule : LSOObject

- (instancetype)initWithJsonPath:(NSString *)jsonPath;



/// 当前Ae模板的总时长;
@property (nonatomic,readonly) CGFloat durationS;


/// 当前AE模板的宽度和高度;
@property(nonatomic, readonly) CGSize size;



/// 图片数量;
@property (nonatomic,readonly) int imageCount;

/**
 里面有多少个图片
 每张图片的宽度和高度, 开始时间点, 时长;
 */
@property (nonatomic, readonly) NSMutableArray<LSOAexImage *> *aexImageArray;







@end

NS_ASSUME_NONNULL_END
