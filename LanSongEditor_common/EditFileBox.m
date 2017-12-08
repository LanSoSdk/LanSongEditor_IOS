//
//  EditFileBox.m
//  LanSongEditorFramework
//
//  Created by sno on 2017/11/16.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "EditFileBox.h"

@implementation EditFileBox

-(id)initWithPath:(NSString *)path
{
    if (!(self = [super init]))
    {
        return nil;
    }
    self.info=[[MediaInfo alloc] initWithPath:path];
    if([self.info prepare]==NO){
        self.info=nil;
        return nil;
    }
    
    if ([self.info hasVideo]) {
        
        //可以等比例缩放.比如缩放一半.
        self.drawpadWidth=self.info.vWidth;  //容器采用原来的尺寸.
        self.drawpadHeight=self.info.vHeight;
        
        if(self.info.vRotateAngle==90 || self.info.vRotateAngle==270){  //如果有旋转角度.则宽高对调.
            CGFloat tmp=self.drawpadWidth;
            self.drawpadWidth=self.drawpadHeight;
            self.drawpadHeight=tmp;
            
            // 如果宽度和高度过大, 则缩小一倍,因为是等比例缩小,不太影响视频质量.
            if(self.drawpadWidth * self.drawpadHeight>=1080*1920){
                self.drawpadWidth/=2.0;
                self.drawpadHeight/=2.0;
            }
        }
        self.videoAngle=self.info.vRotateAngle;
    }
    self.srcVideoPath=path;
    return self;
}
-(id)initWithMediaInfo:(MediaInfo *)info
{
    if (!(self = [super init]) ||info==nil)
    {
        return nil;
    }
    if([info prepare]==NO){
        self.info=nil;
        return nil;
    }
    self.info=info;
    if([info hasVideo]){
        self.srcVideoPath=info.filePath;
        
            //可以等比例缩放.比如缩放一半.
            self.drawpadWidth=self.info.vWidth;  //容器采用原来的尺寸.
            self.drawpadHeight=self.info.vHeight;
            
            if(self.info.vRotateAngle==90 || self.info.vRotateAngle==270){  //如果有旋转角度.
                CGFloat tmp=self.drawpadWidth;
                self.drawpadWidth=self.drawpadHeight;
                self.drawpadHeight=tmp;
            }
            self.videoAngle=self.info.vRotateAngle;
    }
    return self;
}
@end
