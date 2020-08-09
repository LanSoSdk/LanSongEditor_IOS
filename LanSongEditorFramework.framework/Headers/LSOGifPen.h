//
//  LSOGifPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/6.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>



#import <UIKit/UIKit.h>
#import "LSOPen.h"
#import "LSOBitmapAsset.h"



@interface LSOGifPen : LSOPen
{
    CGSize pixelSizeOfImage;
    BOOL hasProcessedImage;
    
    dispatch_semaphore_t imageUpdateSemaphore;
}
@property(readonly) NSURL *gifURL;


-(id)initWithGifURL:(NSURL *)gifUrl drawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

@end
