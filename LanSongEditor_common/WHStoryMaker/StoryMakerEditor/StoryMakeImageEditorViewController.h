//
//  StoryMakeImageEditorViewController.h
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryMakeImageEditorViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@end

/*
 UIImage *image = [UIImage imageNamed:@"bgStory.jpg"];
 StoryMakeImageEditorViewController *storyMakerVc = [[StoryMakeImageEditorViewController alloc] initWithImage:image];
 [self presentViewController:storyMakerVc animated:YES completion:nil];
 */
