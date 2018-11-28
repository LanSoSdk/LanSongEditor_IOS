//
//  LSOProgressHUD.h
//  LanSongEditor_all
//
//  Created by sno on 2018/10/16.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSOProgressHUD : NSObject

-(id) init;
/**
 显示的文字,比如: [NSString stringWithFormat:@"进度:%d",(int)(number.floatValue*100)]
 @param text
 */
-(void)showProgress:(NSString *)text;

/**
 隐藏
 */
-(void)hide;

@end


NS_ASSUME_NONNULL_END

/*
 增加流程:
 LSOProgressHUD *hud;
 hud=[[LSOProgressHUD alloc] init];
 [hud showProgress:[NSString stringWithFormat:@"进度:%d",percent]];
 [hud hide];
 */
