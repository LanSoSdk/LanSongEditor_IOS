//
//  LSOOneLineText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LSOOneLineText : NSObject

//------------------json中的 当前行的 image信息----------------

/**
 当前图片在json中的第几行;
 第1,2,3,4,5...行
 */
@property int  lineIndex;
//当前行的开始时间,单位秒;
@property float startTimeS;

//暂时没有用到
@property float endTimeS;

// 当前行的图片开始帧数
@property (nonatomic, assign) int startFrame;
//暂时不用;
@property (nonatomic, assign) int endFrame;
//当前行图片的id名字 image_0 image_1等
@property NSString  *jsonImageID;

// 当前行json中的图片的宽度
@property int  jsonImageWidth;

// 当前行json总的图片的高度
@property int  jsonImageHeight;

//--------------------文字信息--------------------(一下信息你都可以修改)

/**
 当前行的文字, 文字识别后, 通过 pushText,分割后的当前行的文字
 您可以修改.
 */
@property (nonatomic,copy) NSString *text;
//

/**
 在把文字绘制成图片的时候, 文字的字号, 根据jsonImgWidth jsonImgHeight来选择的合适字号大小
 您可以修改.
 */
@property CGFloat fontSize;


/**
 init的时候默认值是:
 _style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
 _style.lineBreakMode = NSLineBreakByWordWrapping;
 _style.alignment = NSTextAlignmentLeft;
 */
@property NSMutableParagraphStyle *style;



/**
 文字的颜色, 默认是白色
 您可以修改.
 */
@property (nonatomic,copy) UIColor *textColor;


/**
 当前这一行的文字底色;默认是透明;
 */
@property (nonatomic,copy) UIColor *bgColor;
/**
 文字转换为图片对象; 这个图层就是最终要显示的动画图片
 您可以修改.
 */
@property (nonatomic,copy) UIImage *textImage;

//没有用到, 客户使用
@property BOOL isSelected;

//预留
@property NSObject *reserved;
@end

