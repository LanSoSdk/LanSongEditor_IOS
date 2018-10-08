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
    UIImage *image = [UIImage imageNamed:@"lansongbeauty.png"];
    if(image==nil){
        LSLog(@"当前工程中没有增加 lansongbeauty.png文件, 美颜可能效果低一些;");
    }
    return self;
}

-(void)addBeauty:(Pen *)pen
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
                
                [self.beautyFilter addTarget:self.lookupFilter atTextureLocation:0];
                
                [self.lookupFilter setIntensity:0.22];
                
                
                [_lookupFilter imageFromCurrentFramebuffer];
                
                [pen switchFilterWithStartFilter:self.beautyFilter endFilter:self.lookupFilter];
            }else{
                [pen switchFilter:self.beautyFilter];
            }
            LSLog(@"已增加 美颜");
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
-(void)deleteBeauty:(Pen *)pen
{
    @synchronized(self){
        if(pen!=nil){
            [pen switchFilter:nil];
            self.beautyFilter=nil;
            self.lookupFilter=nil;
            LSLog(@"已删除 美颜");
        }
        self.isBeauting=NO;
    }
}
@end

