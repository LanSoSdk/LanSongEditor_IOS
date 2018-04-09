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
        NSLog(@"当前工程中没有增加 lansongbeauty.png文件, 美颜可能效果低一些;");
    }
    return self;
}

-(void)addBeauty:(CameraPen *)cameraPen
{
    @synchronized(self){
        if(cameraPen!=nil && _isBeauting==NO){
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
                
                
//                比如 是_lookupFilter:
//                则
                [_lookupFilter imageFromCurrentFramebuffer];
                
                [cameraPen switchFilterWithStartFilter:self.beautyFilter endFilter:self.lookupFilter];
            }else{
                [cameraPen switchFilter:self.beautyFilter];
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
-(void)deleteBeauty:(CameraPen *)cameraPen
{
    @synchronized(self){
        if(cameraPen!=nil){
            [cameraPen switchFilter:nil];
            self.beautyFilter=nil;
            self.lookupFilter=nil;
            NSLog(@"已删除 美颜");
        }
        self.isBeauting=NO;
    }
}

@end
