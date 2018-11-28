//
//  LSOOneLineText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOOneLineText : NSObject


/**
文字
 */
@property (nonatomic,copy) NSString *text;

/**
 文字颜色
 */
@property (nonatomic,copy) UIColor *textColor;


@end

NS_ASSUME_NONNULL_END
