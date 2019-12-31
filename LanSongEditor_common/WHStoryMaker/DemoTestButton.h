//
//  DemoTestButton.h
//  LanSongEditor_all
//
//  Created by sno on 2019/10/21.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


/// demo用到的临时测试按钮, 请勿使用;
@interface DemoTestButton : UIButton


-(id)initWithHandle:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
