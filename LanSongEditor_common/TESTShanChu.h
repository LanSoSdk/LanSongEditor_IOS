//
//  TESTShanChu.h
//  LanSongEditor_all
//
//  Created by sno on 2019/12/31.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

//  AECompositionDemoVC.h
//  LanSongEditor_all
//
//  Created by sno on 2019/9/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DemoUtils.h"

#define kAEDEMO_AOBAMA 1
#define kAEDEMO_XIANZI 2
#define kAEDEMO_ZAO_AN 3
#define kEDEMO_XIAOHUANGYA 4
#define kEDEMO_MORE_PICTURE 5
#define kEDEMO_REPLACE_VIDEO 6
#define kEDEMO_KADIAN 7
#define kEDEMO_GAUSSIAN_BLUR 8
#define kEDEMO_CONCAT_JSON 9


NS_ASSUME_NONNULL_BEGIN

@interface TESTShanChu : UIViewController

@property int AeType;
@end

NS_ASSUME_NONNULL_END
