//
//  BlazeiceObject.h
//  lexue
//
//  Created by songjie on 13-3-29.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface NSObject(BlazeiceObject)

//send object
-(void)receiveObject:(void(^)(id object))sendObject;
-(void)sendObject:(id)object;

@end
