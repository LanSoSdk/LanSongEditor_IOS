//
//  CSVideoReverse.h
//
//  Created by Chris Sung on 3/5/17.
//  Copyright © 2017 chrissung. All rights reserved.
//
//
//  LanSongVideoReverse.h
//  CSVideoReverse
//
//  Created by sno on 04/12/2017.
//  Copyright © 2017 chrissung. All rights reserved.
//
//使用github上的, CSVideoReverse代码, 实现视频倒序.
//因担心客户同样有同名字的类,造成编译错误,这里改成LanSongVideoReverse;


#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>







#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LanSongVideoReverseDelegate <NSObject>
@optional
- (void)didLanSongVideoReverseFinish:(bool)success withError:(NSError *)error;
@end


/**
 移植自 CSVideoReverse;
 */
@interface LanSongVideoReverse : NSObject {
    
}


@property (weak, nonatomic) id<LanSongVideoReverseDelegate> delegate;


@property (strong, nonatomic) NSDictionary* readerOutputSettings;


/**
 执行倒序,执行完毕后, 会调用didFinishReverse代码

 注意, 此代码仅仅支持视频倒序, 并不支持音频倒序.则输出的视频则没有音频.
 
 @param inputPath 输入路径
 @param outputPath 输出路径
 */
- (void)reverseVideoAtPath:(NSString *)inputPath outputPath:(NSString *)outputPath;

@end

/*
 调用举例.
 NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"mov"];
	
	// create a path for our reversed output video
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	outputPath = [documentsPath stringByAppendingFormat:@"/reversed.mov"];
	
	LanSongVideoReverse *reverser = [[LanSongVideoReverse alloc] init];
	reverser.delegate = self;  //<----有个代理,
 
	[reverser reverseVideoAtPath:inputPath outputPath:outputPath];
 
 -(void)didLanSongVideoReverseFinish:(bool)success withError:(NSError *)error
 {
 if (!success) {
 NSLog(@"%s error: %@", __FUNCTION__, error.localizedDescription);
 return;
 }
 [self showReversedVideo];
 }
 */

