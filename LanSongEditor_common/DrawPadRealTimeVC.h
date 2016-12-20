#import <UIKit/UIKit.h>

#import <LanSongEditorFramework/LanSongEditor.h>


@interface DrawPadRealTimeVC : UIViewController <UIAlertViewDelegate>


//是否增加UI画笔
@property BOOL isAddUIPen;

@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
- (IBAction)updatePixelWidth:(id)sender;

@end