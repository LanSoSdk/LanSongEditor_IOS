//
//  LSOToolButtonsView.h
//  LanSongEditor_all
//
//  Created by sno on 2018/11/17.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "WHStoryMakerHeader.h"
@protocol LSOToolButtonsViewDelegate <NSObject>

@optional

- (void)LSOToolButtonsSelected:(int)index;

@end

@interface DemoToolButtonsView : UIView

- (void)configureView:(NSArray *)array btnWidth:(CGFloat)width viewWidth:(CGFloat)viewWidth;

@property (nonatomic, weak) id <LSOToolButtonsViewDelegate> delegate;

@end
