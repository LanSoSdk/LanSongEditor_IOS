//
//  BeautyManager.m
//  LanSongEditorFramework
//
//  Created by sno on 09/03/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import "BeautyManager.h"
@implementation BeautyManager

-(id)init
{
    if(!(self=[super init])){
        return nil;
    }
    return self;
}

-(void)addBeauty:(LSOPen *)pen
{
    @synchronized(self){
        if(pen!=nil && _isBeauting==NO){
            self.beautyFilter=[[LanSongBeautyTuneFilter alloc] init];
            
            UIImage *image = [UIImage imageNamed:@"lansongbeauty.png"];
            if(image!=nil)
            {
                LanSongPicture *lookupImageSource = [[LanSongPicture alloc] initWithImage:image];
                
                self.lookupFilter = [[LanSongLookupFilter alloc] init];
                [lookupImageSource addTarget:self.lookupFilter atTextureLocation:1];
                [lookupImageSource processImage];
                
                //增加下一级
                [self.beautyFilter addTarget:self.lookupFilter atTextureLocation:0];
                
                [self.lookupFilter setIntensity:0.22];
                
                
                [_lookupFilter imageFromCurrentFramebuffer];
                
                [pen switchFilterWithStartFilter:self.beautyFilter endFilter:self.lookupFilter];
            }else{
                 NSLog(@"当前工程中没有增加 lansongbeauty.png文件, 美颜可能效果低一些;");
                [pen switchFilter:self.beautyFilter];
            }
            NSLog(@"已增加 美颜");
            self.isBeauting=YES;
        }
    }
}
-(void)addBeautyWithVideoOneDo:(LSOVideoOneDo *)videoOneDo
{
    @synchronized(self){
        if(videoOneDo!=nil && _isBeauting==NO){
            self.beautyFilter=[[LanSongBeautyTuneFilter alloc] init];
            
            UIImage *image = [UIImage imageNamed:@"lansongbeauty.png"];
            if(image!=nil)
            {
                LanSongPicture *lookupImageSource = [[LanSongPicture alloc] initWithImage:image];
                
                self.lookupFilter = [[LanSongLookupFilter alloc] init];
                [lookupImageSource addTarget:self.lookupFilter atTextureLocation:1];
                [lookupImageSource processImage];
                
                //增加下一级
                [self.beautyFilter addTarget:self.lookupFilter atTextureLocation:0];
                
                [self.lookupFilter setIntensity:0.22];
                
                
                [_lookupFilter imageFromCurrentFramebuffer];
                
                [videoOneDo setFilterWithStart:self.beautyFilter end:self.lookupFilter];
            }else{
                NSLog(@"当前工程中没有增加 lansongbeauty.png文件, 美颜可能效果低一些;");
                [videoOneDo setFilter:self.beautyFilter];
            }
            NSLog(@"已增加 美颜");
            self.isBeauting=YES;
        }
    }
}
-(void)setWarmCoolEffect:(CGFloat)level
{
    @synchronized(self){
        if(self.beautyFilter!=nil && level>0.0){
            [self.beautyFilter setWarmCoolLevel:level];
        }
    }
}
-(void)deleteBeauty:(NSObject *)object
{
    @synchronized(self){
        if ([object isKindOfClass:[LSOPen class]]) {
            LSOPen *pen=(LSOPen *)object;
              [pen switchFilter:nil];
        }else if([object isKindOfClass:[LSOVideoOneDo class]]){
            LSOVideoOneDo *oneDo=(LSOVideoOneDo *)object;
             [oneDo setFilterWithStart:nil end:nil];
        }
        self.beautyFilter=nil;
        self.lookupFilter=nil;
        NSLog(@"已删除 美颜");
        self.isBeauting=NO;
    }
}
@end

