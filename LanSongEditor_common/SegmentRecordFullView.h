#import <UIKit/UIKit.h>
#import "LanSongUtils.h"



@interface SegmentRecordFullView : UIView
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    NSString *pathToMovie;
    GPUImageView *filteredVideoView;
    CALayer *_focusLayer;
    NSTimer *myTimer;
    UILabel *timeLabel;
    NSDate *fromdate;
    CGRect mainScreenFrame;
    UIButton *photoCaptureButton;
}
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
-(void)setNav:(UINavigationController*)nav;
@end

