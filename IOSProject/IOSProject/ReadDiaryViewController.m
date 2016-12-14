//
//  ReadDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 15..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ReadDiaryViewController.h"

@interface ReadDiaryViewController ()
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *photosScrollView;

@end

@implementation ReadDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.photosScrollView bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:3];
}
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
