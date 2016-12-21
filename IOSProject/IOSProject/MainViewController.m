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
static NSString *const keyFforGroupImage= @"thumbnail";
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
    [self.tabBarController.tabBar setHidden:NO];
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
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForTableView:)];
    
    
    [self.mainTable addGestureRecognizer:longPressGesture];
}

- (void)longPressForTableView:(UILongPressGestureRecognizer *)sender{


    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint currentTouchPosition = [sender locationInView:[sender view]];
    
        NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint:currentTouchPosition];
        
       
        
        
        DiaryModel *diaryData = [DiaryModel sharedData];
        UIAlertController *alert = [[UIAlertController alloc]init];
        
        diaryData.selectedIndex = indexPath.row;
         //선택된 인덱스패스의 값의 마스터와 내 아이디가 같다면
        if([[MyInfoModel sharedData] myIdOfMyInfo] == [diaryData masterOfGroupForSelectedIndex]){
             //수정액션,삭제액션이있는 알럿창을띄운다.
            [alert setModalPresentationStyle:UIModalPresentationFormSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:@"수정" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [NetworkingCenter deleteGroupForGroupID:[diaryData groupIdOfGroupListForSelectedIndex] handler:^(NSString *deleteGroupHandler) {
                    
                    NSLog(@"%@",deleteGroupHandler);
                    [NetworkingCenter showGroupList:^(NSString *groupList) {
                        
                        if([groupList isEqualToString:@"success"]){
                            
                            NSLog(@"정상적으로 불러옴");
                            [self.mainTable reloadData];
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"삭제" message:@"삭제되었습니다." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDestructive handler:nil];
                            [alert addAction:completeAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }];

                }];
            }];
            [alert addAction:cancelAction];
            [alert addAction:modifyAction];
            [alert addAction:deleteAction];
            
            
        }  else{ //없으면 편집권한이없다고 알럿창을띄운다.
            [alert setModalPresentationStyle:UIModalPresentationFormSheet];
            UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:completeAction];
            }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
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
    NSDictionary *dic =  [groupInfo objectForKey:keyForGroupImage];
    [DiaryModel sharedData].selectedGroupImageURL = [dic objectForKey:keyFforGroupImage];
    [[DiaryModel sharedData] lastPostOfGroupForSelectedIndex];
    
   
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    NSDictionary *groupInfo = [[DiaryModel sharedData] groupInfoForIndex:indexPath.row];
    
    NSRange rage ={0,10};
    NSString *fomattedDate = [[groupInfo objectForKey:keyForGroupLastPostDate] substringWithRange:rage];
    
    cell.lastPostDateLabel.text =fomattedDate;
    cell.titleLabel.text = [groupInfo objectForKey:keyForGroupTitle];
    
   
    
    cell.groupPersonCount.text =[NSString stringWithFormat:@"%@",[groupInfo objectForKey:keyForGroupPersonCount]];
    cell.diaryCount.text =[NSString stringWithFormat:@"%@",[groupInfo objectForKey:keyForGroupPostCount]];
    NSDictionary *dic =  [groupInfo objectForKey:keyForGroupImage];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"thumbnail"]];
    
    [cell.thumnailImageView sd_setImageWithURL:url];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    

}
@end
