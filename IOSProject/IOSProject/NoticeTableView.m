//
//  NoticeTableView.m
//  IOSProject
//
//  Created by Yang on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "NoticeTableView.h"

@interface NoticeTableView () <UITableViewDelegate , UITableViewDataSource>

@end

@implementation NoticeTableView



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticeCell"];
        
    }
    
    return cell;
}

@end
