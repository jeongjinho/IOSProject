//
//  ReadViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()
@property (strong, nonatomic) IBOutlet UILabel *TextLabel;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //탭바 히든
    self.tabBarController.tabBar.hidden = YES;
    
    //라벨 텍스트 줄
    [self.TextLabel setText:@"Battle Cruiser Operational Who wanna piece a meat boy?"];
    [self.TextLabel setNumberOfLines:0];
    [self.TextLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
