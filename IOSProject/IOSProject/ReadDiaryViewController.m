//
//  ReadDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 15..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadDiaryViewController.h"
#import "CommentTableViewCell.h"
@interface ReadDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UITextView *articleTextView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputCommentViewBottom;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIImageView *uploadedUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadedUserNameLabel;
@property CGFloat keyboardHeight;
@property CGFloat tempCommentTableX;
@property CGFloat tempInputCommentViewBottom;
@property BOOL  isFoldingMode;

@end

@implementation ReadDiaryViewController
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [NetworkingCenter diaryForPostID:[DiaryModel sharedData].seletedDiaryPK handler:^(NSString *diaryInfo) {
        if([diaryInfo isEqualToString:@"success"]){
        
            DiaryModel *diary = [DiaryModel sharedData];
            //만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
            
//            if([diary myIdOfMyInfo] == [diary likerOfDiaryInfo]){
//            
//                self.likeButton.selected = YES;
//            } else {
//                self.likeButton.selected = NO;
//            }
//            
//            if([diary myIdOfMyInfo] == [diary dislikerOfDiaryInfo]){
//                
//                self.dislikeButton.selected = YES;
//            } else {
//                self.dislikeButton.selected = NO;
//            }

            self.articleTextView.text = [diary contentOfDiaryInfo];
            self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfDiaryInfo]];
            self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfDiaryInfo]];
            
            [self.photosScrollView setContentSize:CGSizeMake(self.photosScrollView.frame.size.width* [diary photosOfDiaryInfo].count, self.photosScrollView.frame.size.height)];
            
            self.pageControl.numberOfPages = [diary photosOfDiaryInfo].count;
            for (NSInteger i = 0; i<[diary photosOfDiaryInfo].count;i++) {
                
                
                NSURL *url = [NSURL URLWithString:[[[diary photosOfDiaryInfo][i] objectForKey:@"photo"] objectForKey:@"thumbnail"]];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.photosScrollView.frame.size.width*i,0, self.photosScrollView.frame.size.width, self.photosScrollView.frame.size.height)];
                
                [imageView sd_setImageWithURL:url];
                NSLog(@"유알엘:%@",url);
                [self.photosScrollView addSubview:imageView];
                
                
            //업로드한사람 사진 , 이름
                [self.uploadedUserImageView sd_setImageWithURL:[diary uploadedUserImageOfDiaryInfo]];
                self.uploadedUserNameLabel.text = [diary uloadedUserNameOfDiaryInfo];
            }

            
        }
   
    }];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFoldingMode = YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self.photosScrollView bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:3];
    //article
    self.articleTextView.delegate = self;
    self.photosScrollView.delegate = self;
    //commentLabelView
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 100;
    
    
    //세그에따른 상단 버튼 히든 여부
    if([self.segueIdentifier isEqualToString:@"ReadVC"]){
        self.nextButton.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showKeyBoardMode:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hideKeyBoardMode:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
}

- (void)hideKeyBoardMode:(NSNotification *)notification{
    if(notification.name == UIKeyboardWillShowNotification){
    [_articleTextView becomeFirstResponder];
    [_articleTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.commentTableX.constant = self.tempCommentTableX;
        self.inputCommentViewBottom.constant = self.tempInputCommentViewBottom;
        [self.view layoutIfNeeded];
    }];
    self.isFoldingMode = YES;
    }
}

- (void)showKeyBoardMode:(NSNotification *)notification{

    if(notification.name == UIKeyboardWillShowNotification){
        
        self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        if(self.isFoldingMode==NO){
            
        } else {
            
            self.tempInputCommentViewBottom = self.inputCommentViewBottom.constant;
            self.tempCommentTableX = self.commentTableX.constant;
            
            [UIView animateWithDuration:1.0f animations:^{
                
                //self.inputCommentViewTop.constant  = -self.keyboardHeight;
                self.commentTableX.constant = -self.keyboardHeight;
                self.inputCommentViewBottom.constant = self.keyboardHeight;
                [self.view layoutIfNeeded];
            }];
        }
        
    }
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    NSLog(@"바뀌기전 사이즈%lf",self.articleTextView.contentSize.height);
   [self.commentTableView.tableHeaderView setFrame:CGRectMake(self.commentTableView.tableHeaderView.frame.origin.x,self.commentTableView.frame.origin.y, self.commentTableView.tableHeaderView.frame.size.width, 420+self.articleTextView.contentSize.height)];
  //  [self.articleTextView setContentSize:CGSizeMake(self.articleTextView.frame.size.width, self.commentTableView.tableHeaderView.frame.size.height-315);
//NSLog(@"바뀌gn 사이즈%lf",self.headerView.frame.size.height);
  // [self.headerView setFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.commentTableView.tableHeaderView.frame.size.height)];
  
    
    [self.commentTableView setContentSize:CGSizeMake(self.commentTableView.frame.size.width, self.commentTableView.contentSize.height+self.articleTextView.contentSize.height-57)];
    NSLog(@"dad%lf",self.commentTableView.contentSize.height);
}

#pragma -mark tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 5 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    
  
    if(indexPath.row ==14){
         cell.commentLabel.text= @"뷁ce";
    
    } else {
        cell.commentLabel.text= @"뷁cell.commentLabel.textㅇㄴㅇㅁㄴ애ㅓㄴㅁ;언ㅁ;엄;ㅓㅇㅁ;넝;ㅁ넝;멍;ㅁ너이;ㅓ;너;ㅓㅇ미;ㅓㅇ미;ㅓㅇ";
        NSLog(@"텍스트 :%@",cell.commentLabel.text);

    }
    
    return cell;
    

}

#pragma -mark scrollView Delegate


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //    CGFloat pageWidth = self.scrollView.frame.size.width;
    //    self.pageControl.currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    self.pageControl.currentPage = self.photosScrollView.contentOffset.x/self.photosScrollView.frame.size.width;
}
#pragma -mark touchUpInSide methods
- (IBAction)touchUpInSideBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)touchUpInSideLikeButton:(id)sender {
//        [NetworkingCenter likeForDiaryID: [[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *likeHandler) {
//            
//            DiaryModel *diary = [DiaryModel sharedData];
//                        //만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
//            
//                        if([diary myIdOfMyInfo] == [diary likerOfDiaryInfo]){
//            
//                            self.likeButton.selected = YES;
//                        } else {
//                            self.likeButton.selected = NO;
//                        }
//            
//                        if([diary myIdOfMyInfo] == [diary dislikerOfDiaryInfo]){
//            
//                            self.dislikeButton.selected = YES;
//                        } else {
//                            self.dislikeButton.selected = NO;
//                        }
//            
//                        self.articleTextView.text = [diary contentOfDiaryInfo];
//                        self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfDiaryInfo]];
//                        self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfDiaryInfo]];
//          
//        }];
//    
//    }

//- (IBAction)touchUpInSideDisLikeButton:(id)sender {
//    
//    
//    [NetworkingCenter dislikeForDiaryID: [[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *dislikeHandler) {
//        
//      
// 
//       
//    }];
//    [self viewWillAppear:YES];

//    [NetworkingCenter diaryForPostID:[DiaryModel sharedData].seletedDiaryPK handler:^(NSString *diaryInfo) {
//        if([diaryInfo isEqualToString:@"success"]){
//            
//            DiaryModel *diary = [DiaryModel sharedData];
//            //만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
//            
//            if([diary myIdOfMyInfo] == [diary likerOfDiaryInfo]){
//                
//                self.likeButton.selected = YES;
//            } else {
//                self.likeButton.selected = NO;
//            }
//            
//            if([diary myIdOfMyInfo] == [diary dislikerOfDiaryInfo]){
//                
//                self.dislikeButton.selected = YES;
//            } else {
//                self.dislikeButton.selected = NO;
//            }
//            
//            self.articleTextView.text = [diary contentOfDiaryInfo];
//            self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfDiaryInfo]];
//            self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfDiaryInfo]];
//            
//        }
//    }];

    
//}

- (IBAction)touchUpInSideEtcButton:(id)sender {
    
    UIAlertController *alert = [[UIAlertController alloc]init];
    NSLog(@"유저아이디 :%ld",[[DiaryModel sharedData] myIdOfMyInfo]);
    NSLog(@"업로드아이디 :%ld",[[DiaryModel sharedData] uploadedUserOfDiaryInfo]);
    if([[DiaryModel sharedData] myIdOfMyInfo] == [[DiaryModel sharedData] uploadedUserOfDiaryInfo]){
        
        [alert setModalPresentationStyle:UIModalPresentationFormSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:@"수정" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [NetworkingCenter deleteFordiaryID:[[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *deleteDiary) {
                
                if([deleteDiary isEqualToString:@"success"]){
                    NSLog(@"성공");
                    [NetworkingCenter diaryListForGroupID:[DiaryModel sharedData].selectedGroupID handler:^(NSString *diaryList) {
                        
                        DiaryModel *diaryData = [DiaryModel sharedData];
                      diaryData.seletedDiaryPK = [[[[diaryData resultsOfDiaryList] firstObject] objectForKey:@"pk"] integerValue];
                        [self viewWillAppear:YES];
                    }];
                     
                    
                    
                    
                }
            }];
           
        }];
        [alert addAction:cancelAction];
        [alert addAction:deleteAction];
        [alert addAction:modifyAction];
        
    } else {
        [alert setTitle:@"유저확인"];
        [alert setMessage:@"작성자가 아닙니다."];
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:completeAction];
    }
    
    
    
  
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)touchInSidePostButton:(id)sender {
    [_articleTextView becomeFirstResponder];
    [_articleTextView resignFirstResponder];

    [UIView animateWithDuration:0.2f animations:^{
        
        self.commentTableX.constant = self.tempCommentTableX;
        self.inputCommentViewBottom.constant = self.tempInputCommentViewBottom;
        [self.view layoutIfNeeded];
    }];
    self.isFoldingMode = YES;
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
