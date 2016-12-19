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

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIImageView *uploadedUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadedUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifiedCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *modifiedStoreButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property CGRect tempArticleViewFrame;
@property CGFloat keyboardHeight;
@property CGFloat tempCommentTableX;
@property CGFloat tempInputCommentViewBottom;
@property CGFloat tempCommentViewTop;
@property NSString *tempArticleString;
@property BOOL  isFoldingMode;

@end

@implementation ReadDiaryViewController
-(void)viewWillAppear:(BOOL)animated{
    [[DiaryModel sharedData].commentsInfo removeAllObjects];
    [super viewWillAppear:animated];
    
    [NetworkingCenter diaryForPostID:[DiaryModel sharedData].seletedDiaryPK handler:^(NSString *diaryInfo) {
        if([diaryInfo isEqualToString:@"success"]){
            [self.commentTableView reloadData];
            DiaryModel *diary = [DiaryModel sharedData];
           // 만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
            
            if([[MyInfoModel sharedData] myIdOfMyInfo] == [diary likerOfDiaryInfo]){
            
                self.likeButton.selected = YES;
            } else {
                self.likeButton.selected = NO;
            }
            
            if([[MyInfoModel sharedData] myIdOfMyInfo] == [diary dislikerOfDiaryInfo]){
                
                self.dislikeButton.selected = YES;
            } else {
                self.dislikeButton.selected = NO;
            }

            self.articleTextView.text = [diary contentOfDiaryInfo];
            [self.articleTextView setEditable:NO];
            self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfDiaryInfo]];
            self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfDiaryInfo]];
            
            [self.photosScrollView setContentSize:CGSizeMake(self.photosScrollView.frame.size.width* [diary photosOfDiaryInfo].count, self.photosScrollView.frame.size.height)];
            
            self.pageControl.numberOfPages = [diary photosOfDiaryInfo].count;
            for (NSInteger i = 0; i<[diary photosOfDiaryInfo].count;i++) {
                
                
                NSURL *url = [NSURL URLWithString:[[[diary photosOfDiaryInfo][i] objectForKey:@"photo"] objectForKey:@"thumbnail"]];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.photosScrollView.frame.size.width*i,0, self.photosScrollView.frame.size.width, self.photosScrollView.frame.size.height)];
                
                [imageView sd_setImageWithURL:url];
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
    //댓글 갱신
  
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
    
    self.commentTextView.delegate = self;
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
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForTableView:)];
    
    
    [self.commentTableView addGestureRecognizer:longPressGesture];
}

- (void)longPressForTableView:(UILongPressGestureRecognizer *)sender{


    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint currentTouchPosition = [sender locationInView:[sender view]];
        
        NSIndexPath *indexPath = [self.commentTableView indexPathForRowAtPoint:currentTouchPosition];
        
        
        DiaryModel *diaryData = [DiaryModel sharedData];
        NSLog(@"코멘트 유저아이디:%ld",[diaryData commentUserPkOfCommentsInfo:indexPath.row]);
        if( [[MyInfoModel sharedData] myIdOfMyInfo]==[diaryData commentUserPkOfCommentsInfo:indexPath.row]){
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [NetworkingCenter deleteCommentsForCommentID:[diaryData commentUserPkOfCommentsInfo:indexPath.row] handler:^(NSString *deleteCommentHandler) {
                
                [diaryData.commentsInfo removeObjectAtIndex:indexPath.row];
                [self.commentTableView reloadData];
                
            }];
            
        }];
            
            [alert addAction:cancelAction];
            [alert addAction:deleteAction];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
        
    
        
    }

}
- (void)hideKeyBoardMode:(NSNotification *)notification{
    if(notification.name == UIKeyboardWillHideNotification){
    [_articleTextView becomeFirstResponder];
    [_articleTextView resignFirstResponder];
    
    [UIView animateWithDuration:1.0f animations:^{
        NSLog(@"바뀌기전 사이즈%lf",self.articleTextView.contentSize.height);
        self.commentTableX.constant = self.tempCommentTableX;
        self.inputCommentViewBottom.constant = self.tempInputCommentViewBottom;
        NSLog(@"바뀌기전 사이즈%lf",self.articleTextView.contentSize.height);
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
                
                NSLog(@"바뀌기전 사이즈%lf",self.articleTextView.contentSize.height);
                [self.view layoutIfNeeded];
            }];
        }
        
    }
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    NSLog(@"바뀌기전 사이즈%lf",self.articleTextView.contentSize.height);
    [self.articleTextView sizeToFit];
    
   [self.commentTableView.tableHeaderView setFrame:CGRectMake(self.commentTableView.tableHeaderView.frame.origin.x,self.commentTableView.frame.origin.y, self.commentTableView.tableHeaderView.frame.size.width, 420+self.articleTextView.contentSize.height)];

 //   [self.commentTableView setContentSize:CGSizeMake(self.commentTableView.frame.size.width, self.commentTableView.contentSize.height+self.articleTextView.contentSize.height-57)];
    NSLog(@"dad%lf",self.commentTableView.contentSize.height);
}

#pragma -mark tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@"DIarycomment%ld",[DiaryModel sharedData].commentsInfo.count);
    return [DiaryModel sharedData].commentsInfo.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    DiaryModel *diaryData = [DiaryModel sharedData];
    
    cell.commentLabel.text = [NSString stringWithFormat:@"%@  %@",[diaryData commentUserNameOfCommentsInfo:indexPath.row],[diaryData contentOfCommentsInfo:indexPath.row]];
  //  [cell.userImageView sd_setImageWithURL:[diaryData commentUserImageOfCommentsInfo:indexPath.row]];
    
    
    return cell;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)touchUpInSideLikeButton:(id)sender {
        [NetworkingCenter likeForDiaryID: [[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *likeHandler) {
            
            DiaryModel *diary = [DiaryModel sharedData];
            //만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
            
            self.likeButton.selected = [diary didlikeOfLikeInfo];
            self.dislikeButton.selected = [diary didDislikeOfLikeInfo];
            self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfLikeInfo]];
            self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfLikeInfo]];
        }];
    }

- (IBAction)touchUpInSideDisLikeButton:(id)sender {
    
    
    [NetworkingCenter dislikeForDiaryID: [[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *likeHandler) {
        
        DiaryModel *diary = [DiaryModel sharedData];
        //만약 좋아요를 눌렀던 게시물이란면 선택된 버튼이미지를 보여준다.
        
        self.likeButton.selected = [diary didlikeOfLikeInfo];
        self.dislikeButton.selected = [diary didDislikeOfLikeInfo];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary likeCountOfLikeInfo]];
        self.dislikeCountLabel.text = [NSString stringWithFormat:@"%ld",[diary dislikeCountOfLikeInfo]];
    }];


    
}

- (IBAction)touchUpInSideEtcButton:(id)sender {
    
    UIAlertController *alert = [[UIAlertController alloc]init];
    NSLog(@"유저아이디 :%ld",[[MyInfoModel sharedData] myIdOfMyInfo]);
    NSLog(@"업로드아이디 :%ld",[[DiaryModel sharedData] uploadedUserOfDiaryInfo]);
    if([[MyInfoModel sharedData] myIdOfMyInfo] == [[DiaryModel sharedData] uploadedUserOfDiaryInfo]){
        
        [alert setModalPresentationStyle:UIModalPresentationFormSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:@"수정" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //댓글 뷰를 안보이게하고
            [self.commentView setHidden:YES];
            //취소를 대비해서 원래 글을 임시저장
            self.tempArticleString = self.articleTextView.text;
           // self.tempArticleViewContentSize = self.artic
            //컨턴츠창을 에디딩 할 수있게하고
            [self.articleTextView setEditable:YES];
            //키보드올리고
            [self.articleTextView becomeFirstResponder];
            //댓글뷰 영역을 없앤다.
            self.tempArticleViewFrame = self.commentTableView.tableHeaderView.frame;
            //상단버튼 교체
            [self.backButton setHidden:YES];
            [self.nextButton setHidden:YES];
            [self.modifiedCancelButton setHidden:NO];
            [self.modifiedStoreButton setHidden:NO];
            
            
            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [NetworkingCenter deleteFordiaryID:[[DiaryModel sharedData] pkOfDiaryInfo] handler:^(NSString *deleteDiary) {
                
                if([deleteDiary isEqualToString:@"success"]){
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
    
    [NetworkingCenter createCommentsForDiaryID:[[DiaryModel sharedData] seletedDiaryPK] content:self.commentTextView.text handler:^(NSDictionary *createCommentHandler) {
        
        [[DiaryModel sharedData].commentsInfo addObject:createCommentHandler];
        [self.commentTableView reloadData];
    }];
    
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
- (IBAction)touchUpInSideModifiedCancelButton:(id)sender {
    //키보드 리자인뺏고
    [self.articleTextView resignFirstResponder];
    //글 수정 할 수업게 하고
    [self.articleTextView setEditable:NO];
    //댓글뷰다시보이게하고
     [self.commentView setHidden:NO];
    
    
    
    self.isFoldingMode = YES;
 
    //임시저장한 텍스트 다시주고
    self.articleTextView.text= self.tempArticleString;
    
     //백버튼 넥스트버튼 보이게하고
    self.backButton.hidden = NO;
    self.nextButton.hidden = NO;
    //취소랑 저장버튼 감추기
    self.modifiedCancelButton.hidden = YES;
    self.modifiedStoreButton.hidden = YES;
    [self.commentTableView.tableHeaderView setFrame:self.tempArticleViewFrame];
}
- (IBAction)touchUpInSideModifiedStoreButton:(id)sender {
    
    
    
    [NetworkingCenter modifyContentForDiaryID:[DiaryModel sharedData].seletedDiaryPK content:self.articleTextView.text handler:^(NSString *modifiedContent) {
        
        if(![modifiedContent isEqualToString:@"fail"]){
            self.articleTextView.text =modifiedContent;
            
            [self.articleTextView resignFirstResponder];
            //글 수정 할 수업게 하고
            [self.articleTextView setEditable:NO];
            //댓글뷰다시보이게하고
            [self.commentView setHidden:NO];
            self.isFoldingMode = YES;
            self.backButton.hidden = NO;
            self.nextButton.hidden = NO;
            //취소랑 저장버튼 감추기
            self.modifiedCancelButton.hidden = YES;
            self.modifiedStoreButton.hidden = YES;
        }
        
    }];
    
    
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
