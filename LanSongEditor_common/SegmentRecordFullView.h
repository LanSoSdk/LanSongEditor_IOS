#import <UIKit/UIKit.h>
#import "LanSongUtils.h"



@interface SegmentRecordFullView : UIView
{
    GPUImageVideoCamera *videoCamera;
    GPUImageMovieWriter *movieWriter;
    /*
     录制的当前段
     */
    NSString *currentSegment;
    
    /*
     画面显示
     */
    GPUImageView *previewView;
    
    /**
     聚焦层.
     */
    CALayer *focusLayer;
    /*
     
     */
    NSTimer *myTimer;
    
    //显示时间
    UILabel *timeLabel;
    
    
    NSDate *fromdate;
    CGRect mainScreenFrame;
    
    /**
     录制按钮
     */
    UIButton *btnRecord;
}
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
-(void)setNav:(UINavigationController*)nav;
@end

