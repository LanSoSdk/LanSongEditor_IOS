//
//  LanSongLOTInfo.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanSongLOTInfo : NSObject

- (instancetype _Nonnull)initWithString:(NSString *)refId width:(NSNumber *)width height:(NSNumber *) height
                                   name:(NSString *)name imagedir:(NSString *)imagedir;


/**
 图片的id号;
 */
@property (nonatomic, readonly, nullable) NSString *imgId;

/**
 图片的宽度
 */
@property (nonatomic, readonly) int imgWidth;

/**
 图片的高度
 */
@property (nonatomic, readonly) int imgHeight;

/**
 图片在用bodymovin导出的时候, 放在images中的名字
 */
@property (nonatomic, readonly, nullable) NSString *imgName;

@end
