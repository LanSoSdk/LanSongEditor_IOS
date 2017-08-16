//
//  VideoPlayViewController.h
//  AudioTest
//
//  Created by sno on 16/8/1.
//
//

#import <UIKit/UIKit.h>

@interface VideoPlayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *libInfo;

//外界输入的视频路径.
@property NSString *videoPath;
@end
