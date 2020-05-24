//
//  AppDelegate.m
//  LanSongEditor_common
//
//  Created by sno on 16/8/3.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoPlayViewController.h"
#import "MainViewController.h"
#import "UIColor+Util.h"




@interface AppDelegate ()
{
    UINavigationController *navigationController;
    MainViewController  *startController;
}
@property(assign, nonatomic)UIBackgroundTaskIdentifier backIden;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    VideoPlayViewController *vl=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
  
    
   // [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    
    MainViewController *rootVC=[[MainViewController alloc] init];
    
    //_gWeekRetValue=0;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:rootVC];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
#error 因Mac模拟器上的GPU和真机差别太大, 我们SDK暂不支持MAC系统的模拟器,请在真机上测试试用,谢谢.
#error current version sdk  cannot support iphone simulator
#endif
    //    navigationController = [[UINavigationController alloc] init];
//    
//    startController = [[CommDemoListTableViewController alloc] initWithNibName:nil bundle:nil];
//    [navigationController pushViewController:startController animated:NO];
//    
//    [self.window setRootViewController:navigationController];
//    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "lansong.LanSongEditor_common" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LanSongEditor_common" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LanSongEditor_common.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//---------lansong++
+(AppDelegate *)getInstance
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

/**
 当APP后台运行的时候,做处理.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self beginBackGroundTask];
}

/**
 进入前台的处理.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBackGround];
}

//开始后台运行的一些任务;
-(void)beginBackGroundTask
{
    NSLog(@"begin  backGround task...");
//    [LSOVideoEditor cancelFFmpeg];
//    if(NSClassFromString(@"LSOVideoEditor") != nil){
//        //         [LSOVideoEditor cancelFFmpeg];
//        if([LSOVideoEditor respondsToSelector:@selector(cancelFFmpeg)]){
//            [LSOVideoEditor cancelFFmpeg];
//        }
//    }
    
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block
        [self endBackGround];
    }];
}
//注销后台
-(void)endBackGround
{
    NSLog(@"endBackGround called.");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}


@end
