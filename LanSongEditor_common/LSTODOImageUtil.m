//
//  LSTODOImageUtil.m
//  LanSongEditor_all
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import "LSTODOImageUtil.h"

@implementation LSTODOImageUtil

+(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:30],
                                 NSForegroundColorAttributeName : [UIColor blueColor],
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image  = [LSTODOImageUtil imageFromString:text attributes:attributes size:size];
    return image;
}
/**
 把文字转换为图片;
 @param string 文字,
 @param attributes 文字的属性
 @param size 转换后的图片宽高
 @return 返回图片
 */
+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, 300));
    
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
