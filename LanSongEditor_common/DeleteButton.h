//
//  DeleteButton.h
//
//  Created by Pandara on 14-8-14.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DeleteButtonStyleDelete,
    DeleteButtonStyleNormal,
    DeleteButtonStyleDisable,
}DeleteButtonStyle;

@interface DeleteButton : UIButton

@property (assign, nonatomic) DeleteButtonStyle style;

- (void)setButtonStyle:(DeleteButtonStyle)style;
+ (DeleteButton *)getInstance;

@end
