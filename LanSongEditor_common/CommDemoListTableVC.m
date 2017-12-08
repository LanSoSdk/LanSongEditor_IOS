//
//  CommDemoListTableViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/10.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "CommDemoListTableVC.h"
#import "CommDemoItem.h"
#import "MBProgressHUD.h"
#import "VideoPlayViewController.h"
#import "LanSongUtils.h"
#import <LanSongEditorFramework/LanSongEditor.h>
enum {
    ID_DELETE_AUDIO,
    ID_DELETE_VIDEO,
    ID_MERGE_VIDEO_AUDIO,
    ID_CUT_AUDIO,
    ID_CUT_VIDEO,
    ID_VIDEO_CONCAT,
    ID_SCALE_VIDEO,
    ID_ADD_PICTURE_WORD,
    ID_VIDEO_FRAME_CROP,
    ID_VIDEO_CROP_ADDWORD,
};
@interface CommDemoListTableVC ()
{
    NSArray *mCommonArray;
    NSString *srcVideo;
    NSString *srcAudio;
    NSString *dstMp4;
    NSString *dstAAC;
    
    MBProgressHUD *demoHintHUD;
}
@end

@implementation CommDemoListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频编辑--基本功能列表";
    
    [SDKFileUtil deleteDir:[SDKFileUtil Path]];
    
    srcVideo=[SDKFileUtil copyAssetFile:@"ping20s" withSubffix:@"mp4" dstDir:[SDKFileUtil Path]];
    srcAudio=[SDKFileUtil copyAssetFile:@"honor30s2" withSubffix:@"m4a" dstDir:[SDKFileUtil Path]];
    
    NSLog(@"srcAudio:%@",srcAudio);
    mCommonArray=[NSArray arrayWithObjects:
                  [[CommDemoItem alloc] initWithID:ID_DELETE_AUDIO hint:@"删除多媒体中的音频"],
                  [[CommDemoItem alloc] initWithID:ID_DELETE_VIDEO hint:@"删除多媒体中的视频"],
                  [[CommDemoItem alloc] initWithID:ID_MERGE_VIDEO_AUDIO hint:@"合并音视频/增加背景音乐/替换音乐"],
                  [[CommDemoItem alloc] initWithID:ID_CUT_AUDIO hint:@"剪切音频"],
                  [[CommDemoItem alloc] initWithID:ID_CUT_VIDEO hint:@"剪切视频"],
                  [[CommDemoItem alloc] initWithID:ID_VIDEO_CONCAT hint:@"视频拼接"],
                  
                  [[CommDemoItem alloc] initWithID:ID_SCALE_VIDEO hint:@"缩放视频"],
                  [[CommDemoItem alloc] initWithID:ID_ADD_PICTURE_WORD hint:@"增加图片或文字"],
                  [[CommDemoItem alloc] initWithID:ID_VIDEO_FRAME_CROP hint:@"视频画面裁剪"],
                  [[CommDemoItem alloc] initWithID:ID_VIDEO_CROP_ADDWORD hint:@"视频画面裁剪增加文字"],
                 nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lanSongEditorCompletionNotificationReceiver:)
                                                 name:@"LanSoEditorCommonCompletion"
                                               object:nil];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    demoHintHUD = [[MBProgressHUD alloc] initWithWindow:window];
    demoHintHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:demoHintHUD];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LanSongVideoEditorProgress:) name:@"LanSongVideoEditorProgress" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
      [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    //显示处理提示,下一版本可以显示处理进度...(暂时没有增加)
-(void)showProgressHUD
{
    if (demoHintHUD!=nil) {
        [demoHintHUD show:YES];
         demoHintHUD.labelText=@"正在处理...";
        demoHintHUD.mode=MBProgressHUDModeIndeterminate;
    }
}

- (void)LanSongVideoEditorProgress:(NSNotification *)notification{
    
    NSDictionary *dict = (NSDictionary *)notification.userInfo;
    NSNumber *number=[dict objectForKey:@"LanSongVideoEditorProgress"];
    if(number!=nil){
        if (demoHintHUD!=nil) {
            demoHintHUD.labelText=[NSString stringWithFormat:@"进度:%d",(int)(number.floatValue*100)];
        }
    }
}

-(void)hideProgressHUD
{
    if (demoHintHUD!=nil) {
        [demoHintHUD hide:YES];
        [self showIsPlayDialog];
    }
}
-(void)startVideoPlayVC
{
    if ([SDKFileUtil fileExist:dstMp4]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstMp4;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else if([SDKFileUtil fileExist:dstAAC]){
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstAAC;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else{
        [LanSongUtils showHUDToast:@"dstMp4 or dstAAC is not exist!"];
    }
}
-(void)showIsPlayDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经处理完毕,是否需要结果预览" delegate:self cancelButtonTitle:@"预览" otherButtonTitles:@"返回", nil];
    [alertView show];
}

- (void)lanSongEditorCompletionNotificationReceiver:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:@"LanSoEditorCommonCompletion"]) {
        
        NSString *completePath = [notification object];
        NSLog(@"返回的字符串是:%@",completePath);
        
        
        dispatch_async( dispatch_get_main_queue(), ^{
        			 [self hideProgressHUD];

        		});
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mCommonArray!=nil) {
        return mCommonArray.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonDemoCall"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonDemoCall"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (mCommonArray!=nil) {
        CommDemoItem *item=(CommDemoItem *)[mCommonArray objectAtIndex:index];
        cell.textLabel.text = item.strHint;
    }else{
        cell.textLabel.text = @"无";
    }
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    CommDemoItem *item=(CommDemoItem *)[mCommonArray objectAtIndex:index];
    
    if ([SDKFileUtil fileExist:dstMp4]) {
        [SDKFileUtil deleteFile:dstMp4];
    }
    dstMp4=[SDKFileUtil genTmpMp4Path];
    
    if ([SDKFileUtil fileExist:dstAAC]) {
        [SDKFileUtil deleteFile:dstAAC];
    }
    dstAAC =[SDKFileUtil genTmpM4APath];
    
    [self showProgressHUD];
    switch (item.demoID) {
            case ID_DELETE_AUDIO:
                [CommDemoItem demoDeleteAudio:srcVideo dstMp4:dstMp4];
                [self hideProgressHUD];
                break;
            case ID_DELETE_VIDEO:
                [CommDemoItem demoDeleteVideo:srcVideo dstAAC:dstAAC];
                [self hideProgressHUD];
                break;
            case ID_MERGE_VIDEO_AUDIO:
                [CommDemoItem demoVideoMergeAudio:srcVideo srcAudio:srcAudio dstMp4:dstMp4];
                [self hideProgressHUD];
                 break;
            case ID_CUT_AUDIO:
                [CommDemoItem demoAudioCutOut:srcAudio dstPath:dstAAC];
                [self hideProgressHUD];
                break;
            case ID_CUT_VIDEO:
                [CommDemoItem demoVideoCutOut:srcVideo dstPath:dstMp4];
                [self hideProgressHUD];
                 break;
            case ID_VIDEO_CONCAT:
                [CommDemoItem demoVideoConcat:srcVideo dstVideo:dstMp4];
                [self hideProgressHUD];
                break;
            case ID_SCALE_VIDEO:
                [CommDemoItem demoScaleWithPath:srcVideo dstPash:dstMp4];
                break;
            case ID_ADD_PICTURE_WORD:
                [CommDemoItem demoAddLayerWithPath:srcVideo dstPash:dstMp4];
                break;
            case ID_VIDEO_FRAME_CROP:
                [CommDemoItem demoCropFrameWithPath:srcVideo dstPash:dstMp4];
                break;
            case ID_VIDEO_CROP_ADDWORD:
                [CommDemoItem demoCropCALayerWithPath:srcVideo dstPash:dstMp4];
                break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {  //修改延时
        [self startVideoPlayVC];
    }else {  //返回
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
