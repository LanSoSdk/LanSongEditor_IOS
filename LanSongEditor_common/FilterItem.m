//
//  FilterItem.m
//  LanSongEditor_all
//
//  Created by sno on 26/11/2017.
//  Copyright © 2017 sno. All rights reserved.
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
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IF1977" filter:[[IF1977Filter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFAmaro" filter:[[IFAmaroFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFBrannan" filter:[[IFBrannanFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFEarlybird" filter:[[IFEarlybirdFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFHefe" filter:[[IFHefeFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFHudson" filter:[[IFHudsonFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFInkwell" filter:[[IFInkwellFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFLomofi" filter:[[IFLomofiFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFSierra" filter: [[IFSierraFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFNashville" filter:[[IFNashvilleFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFSutro" filter:[[IFSutroFilter alloc] init]   ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFRise" filter: [[IFRiseFilter alloc] init]]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFToaster" filter: [[IFToasterFilter alloc] init]]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFValencia" filter: [[IFValenciaFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFWalden" filter: [[IFWaldenFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFXproII" filter: [[IFXproIIFilter alloc] init]  ]];
    [filterItemArray addObject: [[FilterItem alloc] initWithName:@"IFLordKelvin" filter: [[IFLordKelvinFilter alloc] init]  ]];
    
    return filterItemArray;
}
@end
