//
//  Setting.m
//  IOSProject
//
//  Created by Yang on 2016. 12. 3..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "Setting.h"

@interface Setting () <UITableViewDelegate , UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0 , tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];

    /* Section header is in 0th index... */
    if(section == 0)
    {

        label.text = @" ";
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
        
}
    else if(section == 1)
    {
        label.text = @"2번째";
        [view addSubview:label];
         [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    }
    else
    {
       label.text = @"3번째";
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    }
    
  
    return view;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        logoutBtn.titleLabel.text = @"LogOut";
        [cell addSubview:logoutBtn];
    }

    
    return cell;
}

@end
