//
//  LSOProgressHUD.m
//  LanSongEditor_all
//
//  Created by sno on 2018/10/16.
//  Copyright © 2018 sno. All rights reserved.
//

#import "LSOProgressHUD.h"
#import "MBProgressHUD.h"

@interface LSOProgressHUD()
{
    MBProgressHUD *demoHintHUD;
    BOOL isShowing;
}
@end
@implementation LSOProgressHUD
-(id) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    demoHintHUD = [[MBProgressHUD alloc] initWithWindow:window];
    demoHintHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:demoHintHUD];
    
    isShowing=NO;
    return self;
}
-(void)showProgress:(NSString *)text
{
    
    if (demoHintHUD!=nil) {
        if(isShowing==NO){
            [demoHintHUD show:YES];
            demoHintHUD.labelText=text;
            demoHintHUD.mode=MBProgressHUDModeIndeterminate;
            isShowing=YES;
        }else{
            demoHintHUD.labelText=text;
        }
    }
}
-(void)hide
{
    if(isShowing && demoHintHUD!=nil){
            [demoHintHUD hide:YES];
        isShowing=NO;
    }
}
-(void)dealloc
{
    isShowing=NO;
    demoHintHUD=nil;
}
@end
