//
//  SlideEffect.m
//  LanSongEditor_all
//
//  Created by sno on 2017/8/15.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "SlideEffect.h"


@implementation SlideEffect
{
    Pen *mPen;
    CGFloat startTime,endTime;  //单位秒.
    CGFloat viewWidth,viewHeight;
    CGFloat stepPerFrame;
    CGFloat currentX,currentY;
    BOOL needReleaseLayer;

}
/**
 第一秒滑入到中间, 第2,3,4秒显示,第5秒消失.
注意:这里没有检查endTime是否大于startTime,但实际一定要大于.
 
 
 */
-(id)initWithPen:(Pen *)pen FPs:(int)fps startTime:(CGFloat)start  endTime:(CGFloat)end release:(BOOL)needRelease
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    mPen=pen;
    startTime=start;
    endTime=end;
    viewWidth=mPen.drawPadSize.width;
    
    viewHeight=mPen.drawPadSize.height;
    
    needReleaseLayer=needRelease;
    
    //一秒钟划入,则需要走 viewWidth/2的距离. 则一帧step,需要走 viewWidth/(2*fps);
    

    //这里是让中心点移动.
    CGFloat runTime=2.0f*fps;//只运动两秒钟,故这里运动的step就等于   总共2*fps这些帧内走完.
    stepPerFrame=viewWidth/runTime;
    
    
    currentY=viewHeight/2.0f;
    mPen.hidden=YES;
    return self;
 
}
-(void)run:(CGFloat)currentTimeS
{
    CGFloat firstSecond=startTime+1.0;
    CGFloat endSecond=endTime-1.0;
    
    if(currentTimeS>(endTime+1.0) || currentTimeS<startTime){  //不在这个范围,则不显示,mEndMS+1000多出一秒是让右侧滑动的走完.
        mPen.hidden=YES;
        return ;
    }
    mPen.hidden=NO;
    
    if(currentTimeS<(firstSecond)){
        currentX+=stepPerFrame;
    }
    if(currentTimeS >=endSecond){
        currentX+=stepPerFrame;
    }
    
    mPen.positionX=currentX;
    mPen.positionY=currentY;
    
  //  NSLog(@"current postion:%f,%f",currentX,currentY);
}




@end
