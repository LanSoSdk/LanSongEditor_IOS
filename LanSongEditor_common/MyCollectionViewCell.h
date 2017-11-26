//
//  MyCollectionViewCell.h
//  CollectionViewDemo1
//
//  Created by IOS.Mac on 16/10/27.
//  Copyright © 2016年 com.elepphant.pingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMyCollectionViewCellID;

@interface MyCollectionViewCell : UICollectionViewCell


- (void)pushCellWithImage:(UIImage *)img name:(NSString *)name;

@end
