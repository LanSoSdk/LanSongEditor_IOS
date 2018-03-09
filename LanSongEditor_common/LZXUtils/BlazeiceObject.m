//
//  BlazeiceObject.m
//  lexue
//
//  Created by songjie on 13-3-29.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import "BlazeiceObject.h"
#import <objc/runtime.h>

@implementation NSObject(ZXObject)

const char ZXObjectSingleObjectEvent;
-(void)receiveObject:(void(^)(id object))sendObject
{
    objc_setAssociatedObject(self,
                             &ZXObjectSingleObjectEvent,
                             sendObject,
                             OBJC_ASSOCIATION_RETAIN);
}
-(void)sendObject:(id)object
{
    void(^block)(id object) = objc_getAssociatedObject(self,&ZXObjectSingleObjectEvent);
    if(block != nil) block(object);
}

@end
