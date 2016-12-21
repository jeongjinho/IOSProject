//
//  DetailGroupViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 29..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DetailGroupViewController.h"
#import "DetailCollectionViewCell.h"
#import "ReadDiaryViewController.h"


@interface DetailGroupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *centerCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaryCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;

@end

@implementation DetailGroupViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [NetworkingCenter diaryListForGroupID:[DiaryModel sharedData].selectedGroupID handler:^(NSString *result) {
        
        if([result isEqualToString:@"success"]){
            
            [_centerCollectionView reloadData];
            [_centerCollectionView setContentOffset:CGPointZero];

            DiaryModel *diaryData = [DiaryModel sharedData];
            self.diaryCountLabel.text = [NSString stringWithFormat:@"%ld",[diaryData countOfDiaryList]];
            diaryData.seletedDiaryPK = [[[[diaryData resultsOfDiaryList] firstObject] objectForKey:@"pk"] integerValue];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.centerCollectionView.delegate = self;
    self.centerCollectionView.dataSource = self;
    //선택된그룹의 이미지를 데이터센터에서 받아와 화면에 보여준다.
    DiaryModel *diaryData = [DiaryModel sharedData];

    NSURL *url = [NSURL URLWithString:diaryData.selectedGroupImageURL];
    [self.groupImageView sd_setImageWithURL:url];

    self.groupTitleLabel.text = [diaryData groupNameOfGroupListForSelectedIndex];
    self.personCountLabel.text = [NSString stringWithFormat:@"%ld",[diaryData memberCountOfGroupForSelectedIndex]];
}

#pragma -mark collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[DiaryModel sharedData] resultsOfDiaryList].count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 10, 0, 10);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.centerCollectionView.frame.size.width/2-15,self.centerCollectionView.frame.size.height/5*4.5);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryModel *diaryData  = [DiaryModel sharedData];
    DetailCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    NSDictionary *diary = [[DiaryModel sharedData] diaryInResultForIndexPath:indexPath.row];
    //image
    NSURL *url = [NSURL URLWithString:[[[[diary objectForKey:@"photos"] lastObject] objectForKey:@"photo"] objectForKey:@"thumbnail"]];
    [collectionCell.cellImageView sd_setImageWithURL:url];
    //title
    collectionCell.diaryTitleLabel.text = [diary objectForKey:@"content"];
    //likeCount
    collectionCell.likeCountLabel.text =[NSString stringWithFormat:@"%ld",[diaryData likeCountAtIndexOfDiaryList:indexPath.row]];
    //dislikeCount
    collectionCell.dislikeCountLabel.text =[NSString stringWithFormat:@"%ld",[diaryData dislikeCountAtIndexOfDiaryList:indexPath.row]];
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryModel *diaryData = [DiaryModel sharedData];
    NSDictionary *diary = [diaryData diaryInResultForIndexPath:indexPath.row];
    diaryData.seletedDiaryPK = [[diary objectForKey:@"pk"] integerValue];
    //셀선택시 readVC로 이동
    ReadDiaryViewController *readVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadVC"];
    readVC.segueIdentifier = @"ReadVC";
    [self.navigationController pushViewController:readVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark backbutton action
- (IBAction)touchInSideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"넥스트:%@",[[DiaryModel sharedData] nextDiaryListURLOfDiaryList]);
    if(![[[DiaryModel sharedData] nextDiaryListURLOfDiaryList] isKindOfClass:[NSNull class]]){
    
        [NetworkingCenter diaryListForNextURL:[[DiaryModel sharedData] nextDiaryListURLOfDiaryList] handler:^(NSString *result) {
            
            [self.centerCollectionView reloadData];
        }];
    }
}



@end
