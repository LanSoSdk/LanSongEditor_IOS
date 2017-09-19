#import <UIKit/UIKit.h>
#import "LanSongUtils.h"


@interface SimpleVideoFileFilterViewController : UIViewController
{
    LanSongMovie *movieFile;
    LanSongOutput<LanSongInput> *filter;
    LanSongMovieWriter *movieWriter;
    NSTimer * timer;
}

@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
- (IBAction)updatePixelWidth:(id)sender;

@end
