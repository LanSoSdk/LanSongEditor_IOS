//
//  AppDelegate.h
//  LanSongEditor_common
//
//  Created by sno on 16/8/3.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//包含LanSongSDK所有的库头文件
#import <LanSongEditorFramework/LanSongEditor.h>
//自从3.8版本开始, 蓝松SDK图层架构和ffmpeg分离, 分别用两个framework的形式提供, 您需要import两个.
#import <LanSongFFmpegFramework/LanSongFFmpeg.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property int currentFilterIndex;
@property BOOL gDeviceListFirstShow;

+(AppDelegate *)getInstance;
//@property (nonatomic,copy) NSString *currentEditVideo;


@property (nonatomic) LSOVideoAsset *currentEditVideoAsset;



@end


