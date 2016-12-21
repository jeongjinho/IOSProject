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
@property (strong,nonatomic) NSArray *loadImages;
@property NSInteger cellCount;
@property NSString *selectedPhotoImageName;
@end

@implementation WriteViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBarController.tabBar.hidden = YES;
   self.loadImages = [NSArray arrayWithArray:[UtilityClass loadImageInDevicePhotoLibray]];
    self.cellCount = 0;
   
    NSLog(@"self number: %ld",self.loadImages.count);
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    
   
  
    
}

#pragma -mark CollectionView delegate Method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.loadImages.count;
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
        
        UIImage *loadImage = self.loadImages[indexPath.row];
        cell.collectionViewImage.image = loadImage;
    
 });
    return cell;

}
#pragma -mark srcollView Delegate



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.topIamgeView.image = [UtilityClass selectedImageInDevicePhotoLibray:indexPath.row];
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
