//
//  WriteViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 1..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteViewController.h"
#import <Photos/PHCollection.h>
#import <Photos/PHAsset.h>
@interface WriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@end

@implementation WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBarController.tabBar.hidden = YES;
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    
    //라이브러리
   

    __block NSString *localIdentifier = nil;
    // 카메라 롤 앨범을 읽어온다.
    PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                               subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                               options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
//    
//    // 카메라 롤에 있는 사진을 가져온다.
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    [assets enumerateObjectsUsingBlock : ^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        // PHAsset에서 localIdentifier 프로퍼티를 읽는다.
        localIdentifier = asset.localIdentifier;
        *stop = YES;
    }];
 
}
#pragma -mark CollectionView delegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 40;
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

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    return cell;

}
#pragma -mark touch In Side BackButton
- (IBAction)touchInSideBackTapVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
