//
//  FilterItem.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "FilterItem.h"

@implementation FilterItem

-(id)initWithName:(NSString *)name filter:(LanSongOutput <LanSongInput> *)filter
{
    if(!(self=[super init])){
        return nil;
    }
    _name=name;
    _filter=filter;
    return self;
}

/**
 返回的是FilterItem数组.
 仅为常用滤镜的滤镜, 实际您可以任意增删.
 */
+(NSMutableArray *)createDemoFilterArray;
{
    /*
     一下仅仅为常用滤镜的滤镜, 实际您可以任意增删.
     */
    NSMutableArray *filterItemArray=[[NSMutableArray alloc] init];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"无" filter:  [[LanSongFilter alloc] init] ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"美颜" filter:[[LanSongBeautyFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IF1977" filter:[[LanSongIF1977Filter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFAmaro" filter:[[LanSongIFAmaroFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFBrannan" filter:[[LanSongIFBrannanFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFEarlybird" filter:[[LanSongIFEarlybirdFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFHefe" filter:[[LanSongIFHefeFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFHudson" filter:[[LanSongIFHudsonFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFInkwell" filter:[[LanSongIFInkwellFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFLomofi" filter:[[LanSongIFLomofiFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFSierra" filter: [[LanSongIFSierraFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFNashville" filter:[[LanSongIFNashvilleFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFSutro" filter:[[LanSongIFSutroFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFRise" filter: [[LanSongIFRiseFilter alloc] init]]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFToaster" filter: [[LanSongIFToasterFilter alloc] init]]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFValencia" filter: [[LanSongIFValenciaFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFWalden" filter: [[LanSongIFWaldenFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFXproII" filter: [[LanSongIFXproIIFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFLordKelvin" filter: [[LanSongIFLordKelvinFilter alloc] init]  ]];
    
    return filterItemArray;
}
@end
