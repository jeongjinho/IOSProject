//
//  WriteDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 9..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteDiaryViewController.h"

@interface WriteDiaryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong,nonatomic)UICollectionView *leftCollectionView;
@property (strong,nonatomic)UITextView  *rightTextView;
@property (strong,nonatomic)NSMutableArray *loadImages;
@end

@implementation WriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialViews];
    self.loadImages = [NSMutableArray arrayWithArray:[UtilityClass loadImageInDevicePhotoLibray]];

}



- (void)initialViews{

    [self.bottomScrollView setContentSize:CGSizeMake(self.view.frame.size.width*2, self.bottomScrollView.frame.size.height)];
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.showsHorizontalScrollIndicator  = YES;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.leftCollectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height)collectionViewLayout:layout];
    self.rightTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.bottomScrollView.frame.size.width, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height)];
    [self.bottomScrollView addSubview:self.leftCollectionView];
    [self.bottomScrollView addSubview:self.rightTextView];
}

#pragma leftScrollView Delegate Methos
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.loadImages.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0.5, 0, 0.5);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.leftCollectionView.frame.size.width/4-2,self.leftCollectionView.frame.size.width/4-2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WriteDiaryCell" forIndexPath:indexPath];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        UIImage *loadImage = self.loadImages[indexPath.row];
//        cell.collectionViewImage.image = loadImage;
//        
//    });
    
    return cell;
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
