//
//  杭州蓝松科技有限公司
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface DemoLocalVideoVC : UIViewController

@property (copy, nonatomic) void(^backEditVC)(NSDictionary *settings,NSArray *urlArr);

@property (assign, nonatomic) BOOL isEdit;


@end
