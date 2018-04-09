#import <UIKit/UIKit.h>
#import "LanSongUtils.h"



@interface SegmentRecordFullView : UIView
{
//    LanSongVideoCamera *videoCamera;
    CameraPen  *videoCamera;
    LanSongMovieWriter *movieWriter;
    LanSongFilter  *filter;
    /*
     录制的当前段
     */
    NSString *currentSegment;
    
    /*
     画面显示
     */
    LanSongView *previewView;
    
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
-(void)stopCameraCapture;
@end

