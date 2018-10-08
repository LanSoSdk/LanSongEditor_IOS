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

#define SNOLog(msg...) do{ if(DEUG) printf(msg);}while(0)

#define LSLog(fmt, ...) NSLog((@"LanSongSDK: " fmt), ##__VA_ARGS__);

// 设置Dlog可以打印出类名,方法名,行数.
#ifdef LANSONGSDK_DEBUG
#define LSTODO(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#define LANSOSDKLine NSLog(@"[LanSoEditor] function:%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#else
#define LANSOSDKLine ;
#endif

//-------LANSO++  END

