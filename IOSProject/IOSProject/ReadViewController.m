//
//  ReadViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *TextView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //탭바 히든
    self.tabBarController.tabBar.hidden = YES;
    self.myScrollView.delegate = self;
    
    
    [self.TextView setText:@"우리 엄만 매일 내게 말했어 언제나 남자 조심하라고 사랑은 마치 불장난 같아서 다치니까 Eh 엄마 말이 꼭 맞을지도 몰라 널 보면 내 맘이 뜨겁게 달아올라 두려움보단 널 향한 끌림이 더 크니까 Eh 멈출 수 없는 이 떨림은 On and on and on 내 전부를 너란 세상에 다 던지고 싶어 Look at me look at me now 이렇게 넌 날 애태우고 있잖아 끌 수 없어 우리 사랑은 불장난 My love is on fire Now burn baby burn 불장난 My love is on fire So don’t play with me boy 불장난 Oh no 난 이미 멀리 와버렸는걸 어느새 이 모든 게 장난이 아닌 걸 사랑이란 빨간 불씨 불어라 바람 더 커져가는 불길 이게 약인지 독인지 우리 엄마도 몰라 내 맘 도둑인데 왜 경찰도 몰라 불 붙은 내 심장에 더 부어라 너란 기름 kiss him will I diss him I don’t know but I miss him 중독을 넘어선 이 사랑은 crack 내 심장의 색깔은 black 멈출 수 없는 이 떨림은 On and on and on 내 전부를 너란 불길 속으로 던지고 싶어 Look at me look at me now 이렇게 넌 날 애태우고 있잖아 끌 수 없어 우리 사랑은 불장난 My love is on fire Now burn baby burn 불장난 My love is on fire So don’t play with me boy 불장난 걷잡을 수가 없는 걸 너무나 빨리 퍼져 가는 이 불길 이런 날 멈추지 마 이 사랑이 오늘 밤을 태워버리게 whooo"];
    
 
    //라벨 텍스트 줄
  
    
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
