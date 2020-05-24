//
//  NSObject_BlazeiceDEBUG.h
//  lexue
//
//  Created by songjie on 13-3-20.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CRSetError(__ERROR__, __ERROR_CODE__, __DESC__, ...) do { \
NSString *message = [NSString stringWithFormat:__DESC__, ##__VA_ARGS__]; \
NSLog(@"%@", message); \
if (__ERROR__) *__ERROR__ = [NSError errorWithDomain:CRErrorDomain code:__ERROR_CODE__ \
userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,  \
nil]]; \
} while (0)

#ifndef NDEBUG

#define DLOG(format, ...)                   \
NSLog(@"\n%s:%d\n%@",               \
__PRETTY_FUNCTION__, __LINE__,      \
[NSString stringWithFormat:format, ## __VA_ARGS__])

#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.y, (o).size.width, (o).size.height)
#define _point(o) DLOG(@"CGPoint: {%.0f, %.0f}", (o).x, (o).y)

#define DOBJ(obj)  DLOG(@"%s: %@", #obj, [(obj) description])

#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)

#define START_TIMER                 \
NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg)              \
DLOG([NSString stringWithFormat:"%@ Time = %f", msg, \
[NSDate timeIntervalSinceReferenceDate]-start]);

#else

#define DLOG
#define DOBJ
#define MARK
#define START_TIMER
#define END_TIMER

#endif

#ifdef DEBUG

#define LOG(...) NSLog(__VA_ARGS__)
#define LOG_METHOD \
NSLog(@"\nLine:%d\nFunction:%s\n", __LINE__, __FUNCTION__)
#else
#define LOG(...)
#define LOG_METHOD
#endif

#if DEBUG
#define MCRelease(x) [(x) release]
#else
#define MCRelease(x) [(x) release], (x) = nil
#endif

