#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "LanSongFramebuffer.h"

@interface LanSongFramebufferCache : NSObject

// Framebuffer management
- (LanSongFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(LSOTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (LanSongFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(LanSongFramebuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(LanSongFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(LanSongFramebuffer *)framebuffer;

@end
