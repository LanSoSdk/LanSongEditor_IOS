//
//  LSOFullWidthButtonsView.h
//  LanSongEditor_all
//
//  Created by sno on 2018/11/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "DemoUtils.h"

NS_ASSUME_NONNULL_BEGIN




@protocol LSOFullWidthButtonsViewDelegate <NSObject>

- (void)LSOFullWidthButtonsViewSelected:(int)index;
@end

/**
 宽度等于view的宽度view
 */
@interface DemoFullWidthButtonsView : UIScrollView

- (void)configureView:(NSArray *)array width:(CGFloat)width;

@property (nonatomic, weak) id <LSOFullWidthButtonsViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
