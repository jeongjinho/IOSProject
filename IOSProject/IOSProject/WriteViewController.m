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

@interface WriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *topIamgeView;
@property (strong,nonatomic) NSMutableArray *loadImageData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeButtonHeightConstraint;

@end

@implementation WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBarController.tabBar.hidden = YES;
    
    [self loadImageInDevicePhotoLibray];
    NSLog(@"self number: %ld",self.loadImageData.count);

    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    
   
    
}

- (void)loadImageInDevicePhotoLibray{
 
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
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    PHImageManager *photoManager = [PHImageManager defaultManager];
    __block NSMutableArray  *loadImages = [NSMutableArray array];
    
    for (PHAsset *asset in assets) {
        
            [photoManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
               
                [loadImages addObject:result];
                 
            }];
        
        NSLog(@"로드이미지 카운트 : %ld",loadImages.count);
    }
    
    self.loadImageData = [NSMutableArray arrayWithArray:loadImages];
    
    }

#pragma -mark CollectionView delegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"갯수 :%ld",self.loadImageData.count);
    return self.loadImageData.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
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
    
    UIImage *loadImage = self.loadImageData[indexPath.row];
    cell.collectionViewImage.image = loadImage;
    

    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //물어볼것
   // WriteCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.topIamgeView.image = self.loadImageData[indexPath.row];

    
}
#pragma -mark touch In Side BackButton
- (IBAction)touchInSideBackTapVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchInSidedWriteButton:(id)sender {
    NSLog(@"글쓰기 버튼 눌림 ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
