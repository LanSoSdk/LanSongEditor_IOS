//
//  UIDemoToolView.h
//  LanSongEditor_all
//
//  Created by sno on 2018/11/12.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "WHStoryMakerHeader.h"
@protocol UIDemoToolViewDelegate <NSObject>

@optional

- (void)stickerBtnDidSelected;
- (void)pauseResumeBtnDidSelected;
- (void)writeBtnDidSelected;
- (void)clearBtnDidSelected;



@end


@interface UIDemoToolView : UIView

@property (nonatomic, weak) id <UIDemoToolViewDelegate> delegate;

@end
