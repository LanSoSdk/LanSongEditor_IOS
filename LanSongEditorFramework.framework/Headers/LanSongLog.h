//
//  LanSongLog.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/9/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

//显示或注释掉.
#define LANSONGSDK_DEBUG 1

#define LSOLog_w(fmt, ...) NSLog((@"LanSongSDK.Warning: " fmt), ##__VA_ARGS__);
#define LSOLog_e(fmt, ...) NSLog((@"LanSongSDK.Error: " fmt), ##__VA_ARGS__);

#define LSOERROR_RELEASE  LSOLog_e(@"Execution object maybe already dealloced(对象或许已经被释放.)")
// 设置Dlog可以打印出类名,方法名,行数.
#ifdef LANSONGSDK_DEBUG
    #define LSDELETE(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
    #define LANSOSDKLine NSLog(@"LanSongSDK: function:%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);

    #define LSOLog(fmt, ...) NSLog((@"LanSongSDK: " fmt), ##__VA_ARGS__);
    #define LSOLOG(fmt, ...) NSLog((@"LanSongSDK: " fmt), ##__VA_ARGS__);
    #define LSOLog_i(fmt, ...) NSLog((@"LanSongSDK.info: " fmt), ##__VA_ARGS__);
    #define LSOLog_d(fmt, ...) NSLog((@"LanSongSDK.Debug: " fmt), ##__VA_ARGS__);

#else
    #define LSDELETE ;
    #define LANSOSDKLine ;
#define LSOLOG;

    #define LSOLog(fmt, ...);
    #define LSOLog_i(fmt, ...);
    #define LSOLog_d(fmt, ...);

#endif


#define LSORUN_IN_BACKGLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define LSORUN_IN_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//计算时间.
#define CHECK_TIME_START_LSDELETE CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define CHECK_TIME_END_LSDELETE LSOLog(@"当前消耗的时间是: %0.3f(秒)", (CFAbsoluteTimeGetCurrent() - start));
// do something

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//废弃的标注;
#define LSO_DELPRECATED  __attribute__((deprecated))

//隐藏函数,在函数声明后调用;
#define LSO_HIDDEN_FUNCTION __attribute__((visibility("hidden")))

//返回当前bundle中的文件完整路径 NSString类型;
//举例:  UIImage *image=[UIImage imageWithContentsOfFile:LSOBundlePath(@"IMG_0285.JPG")];
#define LSOBundlePath(fileName) [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName]


#define LSOBundleURL(fileName) [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:fileName]
#define LSOScreenWidth [[UIScreen mainScreen] bounds].size.width// 屏幕宽度
#define LSOScreenHeight [[UIScreen mainScreen] bounds].size.height// 屏幕高度
/**
 声明:
 dispatch_semaphore_t _lock;
 初始化:
   _lock = dispatch_semaphore_create(1);
 
 使用:
   LSOX_Lock();
    ..... code .....
   LSOX_Unlock();
 */
#define LSOX_Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
#define LSOX_Unlock() dispatch_semaphore_signal(self->_lock);

//-------LANSO++  END

