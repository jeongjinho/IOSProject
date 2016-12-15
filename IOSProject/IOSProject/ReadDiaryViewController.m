//
//  ReadDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 15..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadDiaryViewController.h"
#import "CommentTableViewCell.h"
@interface ReadDiaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;
@property (weak, nonatomic) IBOutlet UITextView *articleTextView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property CGFloat initialArticleTextViewHeight;
@property CGFloat initialCommentTableViewHeight;
@end

@implementation ReadDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];
    [self.photosScrollView bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:3];
    //commentLabelView
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 80;
    //높이
    self.initialArticleTextViewHeight = self.articleTextView.contentSize.height;
    self.initialCommentTableViewHeight = self.commentTableView.contentSize.height;
    
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    
    
}

#pragma -mark tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    
    if(indexPath.row == 3){
    
    cell.commentLabel.text= @"뷁daskdslkdsaklfdshklfdsjfjdskfjdslfjdsljfds;jfl;dsjf;dsjf;dsj;fdls;fjds;jfds;jdfls;fl;;dsj;dsjg;dsjg;dsjg'dsjf'sdjf'sdjf'sdf'sd'fjds'fj'dsj;dsjds;jfl;sdjfl;dsjfl;dsjfl;dsjf;djs;fjds;fjds;fjsdjl;";
    } else {
    
        cell.commentLabel.text= @"뷁";
    }
    return cell;
    

}

#pragma -mark touchUpInSide methods
- (IBAction)touchUpInSideBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
