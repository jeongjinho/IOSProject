//
//  MainViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.navigationController.navigationBar.hidden = YES;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    self.tabBarController.delegate = self;
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"view tag : %ld",viewController.tabBarController.selectedIndex);
   
   //                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UIViewController *view1 = [storyBoard instantiateViewControllerWithIdentifier:@"leap"];
//    [self presentViewController:view1 animated:YES completion:nil];
  //  [self.tabBarController setModalPresentationCapturesStatusBarAppearance:YES];
    
    
    
   

}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSInteger index = viewController.tabBarItem.tag;
   NSLog(@"selected tag :%ld",index);
   if(index ==1 ){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *modalViewController = [storyBoard instantiateViewControllerWithIdentifier:@"leap"];
        
        [self.tabBarController presentViewController:modalViewController animated:YES completion:nil];
        return false;

    }
    
    return true;
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 20;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    
    v.backgroundView.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:245.0f/255.0f blue:248.0f/255.0f alpha:1];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MainTableViewCell *selectiedCell  = [tableView cellForRowAtIndexPath:indexPath];
        selectiedCell.bottomView.backgroundColor = lightPurpleColor;
    });
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UIViewController *vc = [UtilityClass viewControllerInStoryBoard:@"Main" VCIdentifier:@"next"];
    
    
   // [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.thumnailImageView.image = [UIImage imageNamed:@"Moonbow"];
    
    return cell;
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
