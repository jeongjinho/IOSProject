//
//  DetailGroupViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 29..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DetailGroupViewController.h"
#import "DetailCollectionViewCell.h"



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
    
    [NetworkingCenter diaryListForGroupID:[DiaryModel sharedData].selectedGroupID handler:^(NSString *diaryList) {
        
        if([diaryList isEqualToString:@"success"]){
            
            [_centerCollectionView reloadData];
            [_centerCollectionView setContentOffset:CGPointZero];
            
            
            DiaryModel *diaryData = [DiaryModel sharedData];
            self.diaryCountLabel.text = [NSString stringWithFormat:@"%ld",[diaryData countOfDiaryList]];
        }
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.centerCollectionView.delegate = self;
    self.centerCollectionView.dataSource = self;
   NSURL *url = [NSURL URLWithString:[DiaryModel sharedData].selectedGroupImageURL];
    [self.groupImageView sd_setImageWithURL:url];
    
        DiaryModel *diaryData = [DiaryModel sharedData];
    self.groupTitleLabel.text = [diaryData groupNameOfGroupListForSelectedIndex];
    NSLog(@"그룹타이틀:%ld", [diaryData countOfDiaryList]);
   
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
    
    //You may want to create a divider to scale the size by the way..
    return CGSizeMake(self.centerCollectionView.frame.size.width/2-15,self.centerCollectionView.frame.size.height/5*4.5);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DetailCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    NSDictionary *diary = [[DiaryModel sharedData] diaryInResultForIndexPath:indexPath.row];
    
    //image
    NSURL *url = [NSURL URLWithString:[[[[diary objectForKey:@"photos"] lastObject] objectForKey:@"photo"] objectForKey:@"thumbnail"]];
    [collectionCell.cellImageView sd_setImageWithURL:url];
   
    //title
    collectionCell.diaryTitleLabel.text = [diary objectForKey:@"content"];
    //likeCount
    collectionCell.likeCountLabel.text =[NSString stringWithFormat:@"%ld",[[DiaryModel sharedData] likeCountOfDiaryList]];
    //dislikeCount
    collectionCell.dislikeCountLabel.text =[NSString stringWithFormat:@"%ld",[[DiaryModel sharedData] dislikeCountOfDiaryList]];
    return collectionCell;
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
    
        [NetworkingCenter diaryListForNextURL:[[DiaryModel sharedData] nextDiaryListURLOfDiaryList] handler:^(NSString *nextPage) {
            
            NSLog(@"넥스트페이징성공");
            [self.centerCollectionView reloadData];
        }];
    
    
    }
    

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
