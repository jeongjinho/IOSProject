//
//  WriteViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 1..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteViewController.h"
#import <Photos/PHAsset.h>
#import <Photos/PHCollection.h>
#import <Photos/PHImageManager.h>
#import "WriteCollectionViewCell.h"
#import "WritingConfirmPageViewController.h"
@interface WriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *topIamgeView;
@property (strong,nonatomic) NSMutableArray *loadImageData;
@property NSInteger cellCount;
@end

@implementation WriteViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBarController.tabBar.hidden = YES;
    self.loadImageData = [[NSMutableArray alloc]init];
    self.cellCount = 0;
    [self loadImageInDevicePhotoLibray:self.cellCount];
    NSLog(@"self number: %ld",self.loadImageData.count);
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    
   
  
    
}
- (UIImage *)selectedImageInDevicePhotoLibray:(NSInteger)row{

    __block UIImage *searchedImage;
    PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
    //
    //    // 카메라 롤에 있는 사진을 가져온다.
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *photoManager = [PHImageManager defaultManager];

    
    [photoManager requestImageForAsset:assets[row] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        searchedImage = result;
        
    }];
    return searchedImage;
}
//----------------------------------------------------------------------------
- (void)loadImageInDevicePhotoLibray:(NSUInteger)range{
    
    self.cellCount +=40;
    PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
    //
    //    // 카메라 롤에 있는 사진을 가져온다.
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *photoManager = [PHImageManager defaultManager];
    
  
    
    for (NSInteger i = range;i<assets.count;i++) {
        NSLog(@"i의 카운트 :%ld",i);
            [photoManager requestImageForAsset:assets[i] targetSize:CGSizeMake(80,80) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [self.loadImageData addObject:result];
                //[loadImages addObject:result];
                
                
            }];
        
       // NSLog(@"로드이미지 카운트 : %ld",loadImages.count);
        NSLog(@"cell count :%ld",self.cellCount);
        
        if(self.loadImageData.count ==self.cellCount){
            
            
            return ;
        }
    }
    
  //  self.loadImageData = [NSMutableArray arrayWithArray:loadImages];
    
    }

#pragma -mark CollectionView delegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.loadImageData.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 1, 0, 1);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.bottomCollectionView.frame.size.width/4-2,self.bottomCollectionView.frame.size.width/4-2);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WriteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *loadImage = self.loadImageData[indexPath.row];
        cell.collectionViewImage.image = loadImage;
    
 });
    return cell;

}
#pragma -mark srcollView Delegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat contentHeight = scrollView.contentSize.height;
    if (offsetY < contentHeight-30)
    {
        [self loadImageInDevicePhotoLibray:self.cellCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0 animations:^{
                [self.bottomCollectionView performBatchUpdates:^{
                    [self.bottomCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } completion:nil];
            }];
        });
        
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.topIamgeView.image = [self selectedImageInDevicePhotoLibray:indexPath.row];
}
#pragma -mark touch In Side BackButton
- (IBAction)touchInSideBackTapVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"Next"]){
    
        WritingConfirmPageViewController *writeConfirmVC = segue.destinationViewController;
        writeConfirmVC.groupMainImage = self.topIamgeView.image;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
