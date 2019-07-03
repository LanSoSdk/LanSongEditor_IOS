//
//  FilterItem.h
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoUtils.h"

@interface FilterItem : NSObject

-(id)initWithName:(NSString *)name filter:(LanSongOutput <LanSongInput> *)filter;

@property (nonatomic,assign) NSString *name;
@property (nonatomic,readonly) LanSongOutput<LanSongInput> *filter;


/**
 返回的是FilterItem数组.
 仅为常用滤镜的滤镜, 实际您可以任意增删.
 */
+(NSMutableArray *)createDemoFilterArray;
@end
