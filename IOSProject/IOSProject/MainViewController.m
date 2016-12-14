//
//  MainViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"

static NSString *const keyForGroupTitle = @"group_name";
static NSString *const keyForGroupImage = @"group_image";
static NSString *const keyForGroupLastPostDate = @"last_updated";
static NSString *const keyForGroupPersonCount = @"user_count";
static NSString *const keyForGroupPostCount = @"post_count";
static NSString *const keyForGroupMaster = @"master";
static NSString *const keyForGroupIdentifierNumber = @"id";
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong,nonatomic) NSArray *groupList;


@end

@implementation MainViewController
- (NSArray *)imageInfos {
    return [[DiaryModel sharedData] groupList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NetworkingCenter showGroupList:^(NSString *groupList) {
        
        if([groupList isEqualToString:@"success"]){
            
            NSLog(@"정상적으로 불러옴");
            [self.mainTable reloadData];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      self.navigationController.navigationBar.hidden = YES;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    self.tabBarController.delegate = self;
    
    
    
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


    return [DiaryModel sharedData].groupList.count;
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
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MainTableViewCell *selectiedCell  = [tableView cellForRowAtIndexPath:indexPath];
        selectiedCell.bottomView.backgroundColor = lightPurpleColor;
   
     NSDictionary *groupInfo = [[DiaryModel sharedData] groupInfoForIndex:indexPath.row];
   
    NSInteger groupId = [[groupInfo objectForKey:keyForGroupIdentifierNumber] integerValue];
    NSLog(@"그룹 id%ld",groupId);
    
    [DiaryModel sharedData].selectedGroupID = groupId;
    [DiaryModel sharedData].selectedIndex = indexPath.row;
    [DiaryModel sharedData].selectedGroupImageURL = [groupInfo objectForKey:keyForGroupImage];
  
    
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.thumnailImageView.image = [UIImage imageNamed:@"Moonbow"];
    NSDictionary *groupInfo = [[DiaryModel sharedData] groupInfoForIndex:indexPath.row];
    
    cell.titleLabel.text = [groupInfo objectForKey:keyForGroupTitle];
      cell.lastPostDateLabel.text =[groupInfo objectForKey:keyForGroupLastPostDate];
   
    
    cell.groupPersonCount.text =[NSString stringWithFormat:@"%@",[groupInfo objectForKey:keyForGroupPersonCount]];
    cell.diaryCount.text =[NSString stringWithFormat:@"%@",[groupInfo objectForKey:keyForGroupPostCount]];
    
    NSURL *url = [NSURL URLWithString:[groupInfo objectForKey:keyForGroupImage]];
    
    [cell.thumnailImageView sd_setImageWithURL:url];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    

}
@end
