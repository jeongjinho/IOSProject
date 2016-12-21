//
//  WriteDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 11..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteDiaryViewController.h"
#import "WriteDiaryCollectionViewCell.h"
#import "DiaryModel.h"
@interface WriteDiaryViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//UI
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong,nonatomic)UICollectionView *photoCollectionView;
@property (strong,nonatomic)UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
//애니메이션
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomscrollBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foldButtonWidth;
@property (assign,nonatomic)CGFloat keyboardHeight;
@property  (assign,nonatomic)BOOL isFoldingMode;
@property CGFloat tempPhotoWidth;
@property CGFloat tempTop;
@property CGFloat tempBottom;
@property CGFloat tempFoldButtonWidth;

//photo data
@property NSArray *loadImages;
//selectied photos at bottom photoCollectionView
//@property NSMutableArray *selectedPhotos;
@property NSInteger groupId;
@end

@implementation WriteDiaryViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [[DiaryModel sharedData].selectedPhotos removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //두배해주고
    [self initializeComponent];
  self.groupId = [DiaryModel sharedData].selectedGroupID;
    
    self.loadImages = [NSArray arrayWithArray:[UtilityClass loadImageInDevicePhotoLibray]];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showKeyBoardMode:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
}



#pragma -mark  bottom collectionView delegate methos
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
    
    return CGSizeMake(self.photoCollectionView.frame.size.width/4-2,self.photoCollectionView.frame.size.width/4-2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WriteDiaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WriteDiaryCell" forIndexPath:indexPath];

        cell.label.hidden =YES;
    
            UIImage *loadImage = self.loadImages[indexPath.row];
            cell.imageView.image = loadImage;
            for (NSNumber *rowNumber in [DiaryModel sharedData].selectedPhotos) {
                
                if(rowNumber.integerValue ==indexPath.row){
                NSLog(@"인덱스패스:%ld",indexPath.row);
                    NSLog(@"저장된 인덱스패스%ld",rowNumber.integerValue);
                    cell.label.hidden =NO;
                
                }
            }
    
    

    return cell;
}
//==== 되긴하는데 카운트가 이상함
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryModel *diaryModel = [DiaryModel sharedData];
     WriteDiaryCollectionViewCell *cell = (WriteDiaryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
       if(cell.label.hidden ==YES&&diaryModel.selectedPhotos.count<6){
        cell.label.hidden = NO;
   
        NSNumber *indexPathNumber = [NSNumber numberWithInteger:indexPath.row];
        [diaryModel.selectedPhotos addObject:indexPathNumber];
       
    } else{
        //선택되어진것이라면
        if (cell.label.hidden == NO){
            //기존에선택된것에서 찾는다.
            for (NSInteger i=0;i<diaryModel.selectedPhotos.count;i++) {
                NSInteger selectedNumber = [diaryModel.selectedPhotos[i] integerValue];
                
                //비교해서 지우고 라벨에 체크한것도 해제한다.
                if(indexPath.row == selectedNumber){
                    [diaryModel.selectedPhotos removeObjectAtIndex:i];
                    cell.label.hidden = YES;
                    ;;
                   
                }
                
                
            }

                    
            

            
        } else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"사진선택" message:@"6개까지 선택할 수 있습니다" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }

    }
    if(diaryModel.selectedPhotos.count>0){
        self.topImageView.image =[UtilityClass selectedImageInDevicePhotoLibray:[diaryModel.selectedPhotos[diaryModel.selectedPhotos.count-1] integerValue]];
    } else {
    
        self.topImageView.image = nil;
    }
    
    
}

#pragma -mark notification method
- (void)showKeyBoardMode:(NSNotification *)notification{
    self.writeButton.userInteractionEnabled = NO;

    if(notification.name == UIKeyboardWillShowNotification){
    
        self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        if(self.isFoldingMode==NO){

        } else {
        
            self.tempPhotoWidth = self.photoWidth.constant;
            self.tempTop = self.photoTop.constant;
            self.tempBottom = self.bottomscrollBottom.constant;
            self.tempFoldButtonWidth  =self.foldButtonWidth.constant;
            [UIView animateWithDuration:1.0f animations:^{
                
                self.photoWidth.constant  = -self.view.frame.size.width/2;;
                self.foldButtonWidth.constant= 15;
                self.photoTop.constant = -self.keyboardHeight;
                self.bottomscrollBottom.constant = self.keyboardHeight;
                [self.view layoutIfNeeded];
            }];

        
        }
    }


}
- (IBAction)touchUpInSIdeStoreButton:(id)sender {
    
    NSMutableArray *imagesInfo =[[NSMutableArray alloc]init];
    for (NSInteger i=0;i<[DiaryModel sharedData].selectedPhotos.count;i++) {
        DiaryModel *diary = [DiaryModel sharedData];
        
   [imagesInfo addObject:[UtilityClass selectedImageInDevicePhotoLibray: [diary.selectedPhotos[i] integerValue]]];
    }
    
    [NetworkingCenter postDiaryWithGroupId:self.groupId postText:self.textView.text selectedImages:imagesInfo postDiaryHander:^(NSString *result) {
        
        UIAlertController *alert = [[UIAlertController alloc]init];
        
        if([result isEqualToString:@"success"]){
        
            alert = [UIAlertController alertControllerWithTitle:@"포스트 성공" message:@"정상적으로 회원님의 일기가 올라갔습니다." preferredStyle:UIAlertControllerStyleAlert];
            
        
        } else {
            alert = [UIAlertController alertControllerWithTitle:@"포스트 실패" message:@"다시한번 시도해 주세요." preferredStyle:UIAlertControllerStyleAlert];
        }
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];

            [[DiaryModel sharedData].selectedPhotos removeAllObjects];
            
        }];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
}

- (IBAction)touchUpInSideCancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma  -mark touchUpInsideButton methods
//----------Up 붙이기
- (IBAction)touchInSideFoldButton:(id)sender {
    NSLog(@"눌림");
    self.writeButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5f animations:^{
        
        self.photoWidth.constant = self.tempPhotoWidth;
        self.photoTop.constant = self.tempTop;
        self.bottomscrollBottom.constant = self.tempBottom;
        self.foldButtonWidth.constant =self.tempFoldButtonWidth;
        [self.view layoutIfNeeded];
    }];
    self.isFoldingMode = YES;
    [_textView resignFirstResponder];
}
- (void)initializeComponent{
    self.isFoldingMode = YES;
//    self.selectedPhotos = [[NSMutableArray alloc]init];
    //scrollView
    [self.bottomScrollView setContentSize:CGSizeMake(self.view.frame.size.width*2, self.bottomScrollView.frame.size.height)];
    
    //PhotoCollectionView
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.bottomScrollView.frame.origin.x,0,self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height) collectionViewLayout:collectionLayout];
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    [self.photoCollectionView registerClass:[WriteDiaryCollectionViewCell class] forCellWithReuseIdentifier:@"WriteDiaryCell"];
  //  [self.photoCollectionView setAllowsMultipleSelection:YES];
    //textView
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(self.bottomScrollView.frame.size.width,0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height)];
    self.textView.delegate = self;
   //add subView
    [self.bottomScrollView addSubview:self.photoCollectionView];
    [self.bottomScrollView addSubview:self.textView];

}

- (IBAction)touchUpInSideSelectButton:(id)sender {
    UIButton *button = sender;
    if([button isKindOfClass:[UIButton class]]){
        switch (button.tag) {
            case 0:
                
                [self.bottomScrollView setContentOffset:CGPointZero animated:YES];
                break;
            case 1:
                
                [self.bottomScrollView setContentOffset:CGPointMake(self.bottomScrollView.contentSize.width/2,0) animated:YES];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
