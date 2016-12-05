//
//  ReadViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadViewController.h"
#import "CustomTextField.h"
#import "ViewUpBorder.h"
#import "CommentBorder.h"


@interface ReadViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic)  UITextView *TextView;
@property (strong, nonatomic) IBOutlet ViewUpBorder *commentView;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UITableView *TextTableView;
@property (weak, nonatomic) IBOutlet CommentBorder *commentTextField;
@property NSInteger count;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *imagePageCtl;
@property (nonatomic)NSArray *Blackpink;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationController.navigationBar.hidden =YES;
    self.TextView = [[UITextView alloc] init];
        self.TextView.text = @"툭하면 거친 말들로 내 맘에 상처를 내놓고 미안하단 말 한마디 없이 또 나 혼자 위로하고 오늘 하루도 혹시 날 떠날까 늘 불안해 해 I just want you to stay 점점 무뎌져 가는 너의 그 무표정 속에 천천히 내려놓자며 거울에 속삭이곤 해 날 당연하게 생각하는 너지만 그게 너다워 그래도 stay stay stay with me 널 닮은 듯한 슬픈 멜로디 이렇게 날 울리는데 eh eh네 향기는 달콤한 felony 너무 밉지만 사랑해 어두운 밤이 날 가두기 전에 내 곁을 떠나지마 아직 날 사랑하니 내 맘과 같다면 오늘은 떠나지마 굳이 너여야만 하는 이유는 묻지마 그저 내 곁에 stay with me (It goes a little something like)지금 당장 많은 걸 바라는 게 아냐 그저 내 곁에 stay with me ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ";

    //self.commentTextField.delegate = self;
    
    //탭바 히든
    self.tabBarController.tabBar.hidden = YES;
    self.TextTableView.delegate = self;
    self.TextTableView.dataSource = self;
    
    self.Blackpink = @[@{@"name":@"블랙핑크",@"image":@"블랙핑크2.jpeg"},
                       @{@"name":@"블랙핑크",@"image":@"블랙핑크3.jpeg"},
                       @{@"name":@"블랙핑크",@"image":@"블랙핑크4.jpeg"},
                       @{@"name":@"블랙핑크",@"image":@"블랙핑크5.jpeg"},
                       @{@"name":@"제니",@"image":@"제니.jpeg"},
                       @{@"name":@"지수",@"image":@"지수.jpg"},
                       @{@"name":@"블랙핑크",@"image":@"블랙핑크1.jpeg"}];
    
    
    
    //이미지 불러오기
    NSUInteger i = 0;
    NSMutableArray *thisImg = [[NSMutableArray alloc] init];
    
    for(NSDictionary *songName in self.Blackpink){
        [thisImg addObject:[songName objectForKey:@"image"]];
    }
    i = thisImg.count;
    [self.imageScrollView setContentSize:CGSizeMake(self.imageScrollView.frame.size.width * i, self.imageScrollView.frame.size.height)];
    
    for (NSInteger i = 0 ; i < thisImg.count; i += 1) {
        UIImage *img = [[UIImage alloc] init];
        img = [UIImage imageNamed:[thisImg objectAtIndex:i]];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(self.imageScrollView.frame.size.width*i, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height);
        
        imgView.contentMode = UIViewContentModeScaleToFill;
        [imgView setImage:img];
        [self.imageScrollView addSubview:imgView];
        if(i == 0){
            NSLog(@"이미지");
            
        }
    }

    
  
#pragma mark - ScrollView Option

      //ScrollView에 필요한 옵션을 적용한다.
    //vertical = 세로 , Horizontal = 가로 스크롤효과를 적용.
    self.imageScrollView.showsVerticalScrollIndicator=NO;
    self.imageScrollView.showsHorizontalScrollIndicator=YES;
    // 스크롤이 경계에 도달하면 바운싱효과를 적용
    self.imageScrollView.alwaysBounceVertical=NO;
    self.imageScrollView.alwaysBounceHorizontal=YES;
    //페이징 가능 여부 YES
    self.imageScrollView.pagingEnabled=YES;
    self.imageScrollView.delegate=self;
    //pageControl에 필요한 옵션을 적용한다.
    //현재 페이지 index는 0
    self.imagePageCtl.currentPage =0;
    //페이지 갯수
    self.imagePageCtl.numberOfPages=self.Blackpink.count;
    //페이지 컨트롤 값변경시 이벤트 처리 등록
    [self.imagePageCtl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.imagePageCtl];
    
    self.TextTableView.tableFooterView.hidden = YES;

#pragma mark - Text Scroll View
    
        //스크롤 적용 !
    [self.TextView scrollRectToVisible: CGRectMake(0,0,1,1) animated:NO];
    
    [self.TextView sizeToFit];
    
   
    
}


//스크롤이 변경될때 page의 currentPage 설정
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //    CGFloat pageWidth = self.scrollView.frame.size.width;
    //    self.pageControl.currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    self.imagePageCtl.currentPage = self.imageScrollView.contentOffset.x/self.imageScrollView.frame.size.width;
}
//페이지 컨트롤 값이 변경될때, 스크롤뷰 위치 설정
- (void) pageChangeValue:(id)sender {
    UIPageControl *pControl = (UIPageControl *) sender;
    [self.imageScrollView setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
}
// 스크롤바를 보였다가 사라지게 함
- (void)viewDidAppear:(BOOL)animated
{
    [self.imageScrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

//셀 갯수
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    UIFont *yourFont = [UIFont systemFontOfSize:15];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.TextView.text
                                    attributes:@{NSFontAttributeName: yourFont}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){tableView.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    NSLog(@"%@", NSStringFromCGRect(rect));
    return rect.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
//    self.TextTableView.tableFooterView.hidden = YES;
//    self.TextTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
//    UITextView* headerView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
//    
//    CGRect textViewFrame = self.TextView.frame;
//    textViewFrame.size.height = self.TextView.contentSize.height;
//    
//    headerView.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
//    headerView.layer.borderWidth = 1.0;
//
//    headerView.backgroundColor = [UIColor clearColor];
//    headerView.textColor = [UIColor blackColor];
//    headerView.textAlignment = NSTextAlignmentLeft;
//    headerView.text =  self.TextView.text;
//     [headerView setFont:[UIFont boldSystemFontOfSize:15]];
//    
//    [self.TextTableView.tableHeaderView addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 200, 120)];
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = self.TextView.text;
    [self.view addSubview:label];
    [label sizeToFit];
    
    return label;
   
   
    //return headerView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndexCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexCell"];

    }
    
    return cell;
}

//cell 재사용시 애니메이션 ...
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;

    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}


@end
