//
//  杭州蓝松科技有限公司
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//
#import "DemoLocalVideoVC.h"
#import "DemoPhotoAlbumCell.h"
#import "DemoUtils.h"

@interface DemoLocalVideoVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) PHAssetMediaType mediaType;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *images;
@end
static NSString * const reuseIdentifier = @"Cell";


#pragma mark -- PHAsset (PLSImagePickerHelpers)

@implementation PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL {
    __block NSURL *url = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    if (self.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            url = urlAsset.URL;
            dispatch_semaphore_signal(semaphore);
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return url;
}

/**

 @param phAsset <#phAsset description#>
 @param targetSize <#targetSize description#>
 @return <#return value description#>
 */
- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    __block UIImage *image = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    //    options.networkAccessAllowed = YES;
    //    options.synchronous = YES;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    PHImageManager *manager = [PHImageManager defaultManager];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    options.normalizedCropRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    
    [manager requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return image;
}

@end


@implementation DemoLocalVideoVC
{
//    LSOEditMode *editor;
    DemoProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    progressHUD=[[DemoProgressHUD alloc] init];
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.assets = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (([UIScreen mainScreen].bounds.size.width-32) / 3) - 1;
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    layout.sectionInset = UIEdgeInsetsMake(20, 16, 0, 16);
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DemoPhotoAlbumCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self fetchAssetsWithMediaType:self.mediaType];
                    
                } else {
                    
                }
            });
        }];
    } else if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied) {
        
    } else {
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoPhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    PHAsset *asset = self.assets[indexPath.item];
    cell.asset = asset;
    if (self.images.count == self.assets.count) {
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.image = self.images[indexPath.row];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *pAsset = self.assets[indexPath.item];
    NSURL *url = [pAsset movieURL];
    if (!url) { // 有可能第一次获取不到，造成崩溃，再获取一次
        url = [pAsset movieURL];
    }
        [AppDelegate getInstance].currentEditVideoAsset=[[LSOVideoAsset alloc] initWithURL:url];
        [self.navigationController popViewControllerAnimated:NO];
}

-(void)progressBlock:(CGFloat)progress
{
     [progressHUD showProgress:[NSString stringWithFormat:@"progress is:%f",progress]];
}
-(void)completedBlock:(NSString *)dstPath
{
    [progressHUD hide];
    [AppDelegate getInstance].currentEditVideoAsset=[[LSOVideoAsset alloc] initWithPath:dstPath];
    [self.navigationController popViewControllerAnimated:NO];
}
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType {
    
    //    __strong typeof(self)strongSelf = self;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    //            CGFloat scale = 1;
    CGFloat w = (([UIScreen mainScreen].bounds.size.width-32) / 3) - 1;
    CGSize size = CGSizeMake(w * scale, w * scale);
    
    WS(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        weakSelf.images = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAsset *asset = (PHAsset *)obj;
            if(obj!=nil){
                [assets addObject:obj];
                UIImage *image1=[asset imageURL:asset targetSize:size];
                if(image1!=nil){
                    [weakSelf.images addObject:image1];
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.assets = assets;
            [weakSelf.collectionView reloadData];
        });
    });
}
@end
