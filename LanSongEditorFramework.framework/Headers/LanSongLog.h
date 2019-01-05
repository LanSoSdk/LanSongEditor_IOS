//
//  LanSongLog.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/9/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

//----LANSO++
//显示或注释掉.
#define LANSONGSDK_DEBUG 1

#define LSLog(fmt, ...) NSLog((@"LanSongSDK: " fmt), ##__VA_ARGS__);

#define LSLog_i(fmt, ...) NSLog((@"LanSongSDK.info: " fmt), ##__VA_ARGS__);
#define LSLog_w(fmt, ...) NSLog((@"LanSongSDK.Warning: " fmt), ##__VA_ARGS__);
#define LSLog_e(fmt, ...) NSLog((@"LanSongSDK.Error: " fmt), ##__VA_ARGS__);

// 设置Dlog可以打印出类名,方法名,行数.
#ifdef LANSONGSDK_DEBUG
#define LSTODO(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#define LANSOSDKLine NSLog(@"[LanSoEditor] function:%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#else
#define LANSOSDKLine ;
#endif


#define LSTODO_CHECK_TIME_START CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define LSTODO_CHECK_TIME_END LSLog(@"当前消耗的时间是: %0.3f(秒)", (CFAbsoluteTimeGetCurrent() - start));
// do something
;



#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//-------LANSO++  END

