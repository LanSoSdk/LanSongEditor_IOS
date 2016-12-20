//
//  LanSongUtils.h
//  LanSongEditor_all
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG 1
#define SNOLog(msg...) do{ if(DEUG) printf(msg);}while(0)



@interface LanSongUtils : NSObject

+(void) showHUDToast:(NSString *)strHint;

@end
