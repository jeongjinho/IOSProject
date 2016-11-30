//
//  ReadViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadViewController.h"
#import "CustomTextField.h"

@interface ReadViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UITableView *TextTableView;
@property (weak, nonatomic) IBOutlet CustomTextField *commentTextField;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.commentTextField.delegate = self;
    
    //탭바 히든
    self.tabBarController.tabBar.hidden = YES;
    
    
    [self.TextView setText:@"우리 엄만 매일 내게 말했어 언제나 남자 조심하라고 사랑은 마치 불장난 같아서 다치니까 Eh 엄마 말이 꼭 맞을지도 몰라 널 보면 내 맘이 뜨겁게 달아올라 두려움보단 널 향한 끌림이 더 크니까 Eh 멈출 수 없는 이 떨림은 On and on and on 내 전부를 너란 세상에 다 던지고 싶어 Look at me look at me now 이렇게 넌 날 애태우고 있잖아 끌 수 없어 우리 사랑은 불장난 My love is on fire Now burn baby burn 불장난 My love is on fire So don’t play with me boy 불장난 Oh no 난 이미 멀리 와버렸는걸 어느새 이 모든 게 장난이 아닌 걸 사랑이란 빨간 불씨 불어라 바람 더 커져가는 불길 이게 약인지 독인지 우리 엄마도 몰라 내 맘 도둑인데 왜 경찰도 몰라 불 붙은 내 심장에 더 부어라 너란 기름 kiss him will I diss him I don’t know but I miss him 중독을 넘어선 이 사랑은 crack 내 심장의 색깔은 black 멈출 수 없는 이 떨림은 On and on and on 내 전부를 너란 불길 속으로 던지고 싶어 Look at me look at me now 이렇게 넌 날 애태우고 있잖아 끌 수 없어 우리 사랑은 불장난 My love is on fire Now burn baby burn 불장난 My love is on fire So don’t play with me boy 불장난 걷잡을 수가 없는 걸 너무나 빨리 퍼져 가는 이 불길 이런 날 멈추지 마 이 사랑이 오늘 밤을 태워버리게 whooo툭하면 거친 말들로 내 맘에 상처를 내놓고 미안하단 말 한마디 없이 또 나 혼자 위로하고 오늘 하루도 혹시 날 떠날까 늘 불안해 해 I just want you to stay 점점 무뎌져 가는 너의 그 무표정 속에 천천히 내려놓자며 거울에 속삭이곤 해 날 당연하게 생각하는 너지만 그게 너다워 그래도 stay stay stay with me 널 닮은 듯한 슬픈 멜로디 이렇게 날 울리는데 eh eh 네 향기는 달콤한 felony 너무 밉지만 사랑해 어두운 밤이 날 가두기 전에 내 곁을 떠나지마 아직 날 사랑하니내 맘과 같다면 오늘은 떠나지마"];
    
        //스크롤 적용 !
    [self.TextView scrollRectToVisible: CGRectMake(0,0,1,1) animated:NO];
    
    [self.TextView sizeToFit];
    
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(borderWidth, borderWidth, self.commentView.frame.size.width+30, self.commentView.frame.size.height);
    border.borderWidth = borderWidth;
    [self.commentView.layer addSublayer:border];
    self.commentView.layer.masksToBounds = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
