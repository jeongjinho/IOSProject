//
//  ReadDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 15..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadDiaryViewController.h"
#import "CommentTableViewCell.h"
@interface ReadDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UITextView *articleTextView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputCommentViewBottom;
@property CGFloat keyboardHeight;
@property CGFloat tempCommentTableX;
@property CGFloat tempInputCommentViewBottom;
@property BOOL  isFoldingMode;
@end

@implementation ReadDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFoldingMode = YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self.photosScrollView bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:3];
    //article
    self.articleTextView.delegate = self;
    //commentLabelView
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 100;
    self.articleTextView.text = @"sdjklasdlkasjdlkasjdlksajdlksajdlsajdlsajdlasdjlsakdjsladjlsakdjlaskjdlkasdjlaskjdlaksjdlksajdlsajdlsajdlasjdlasdjalsdjlsajdlaskdsdsdasdklajdklasjdjasldjlaksdjsalkdjlsakdjlasdjalskdjalksdjalsdjaljdlaskz43434343434343434dsfjdsfhdlskfhdlskfhdlskfhdskfhdkslfhdlskfhldkshr3248329048320948302984093284302984092384039284032984032948230948055555555555sadsdsa;djas;dja;sldjas;jdals;jdas;djas;ldjas;ldjas;jd;";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showKeyBoardMode:)
     name:UIKeyboardWillShowNotification
     object:nil];
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
    [self.commentTableView.tableHeaderView setFrame:CGRectMake(self.commentTableView.tableHeaderView.frame.origin.x,self.commentTableView.frame.origin.y, self.commentTableView.tableHeaderView.frame.size.width, 370+self.articleTextView.contentSize.height)];
NSLog(@"바뀌gn 사이즈%lf",self.headerView.frame.size.height);
    [self.headerView setFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.commentTableView.tableHeaderView.frame.size.height)];
    

    }

#pragma -mark tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 15;
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

#pragma -mark touchUpInSide methods
- (IBAction)touchUpInSideBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
