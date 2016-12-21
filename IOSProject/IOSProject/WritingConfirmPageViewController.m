//
//  WritingConfirmPageViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 4..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WritingConfirmPageViewController.h"

#import "SearchPhoneNumberTableViewCell.h"
#import "MainColorTextField.h"
#import "CircleButton.h"
#import "CustomIndicateView.h"
static NSString *const name = @"name";
static NSString *const phoneNumber = @"phoneNumber";

@interface WritingConfirmPageViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *selectiedImageView;
@property (weak, nonatomic) IBOutlet MainColorTextField *groupNameField;
@property (weak, nonatomic) IBOutlet MainColorTextField *searchPhoneNumberField;
@property (weak, nonatomic) IBOutlet UITableView *searchedTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *selectedPeoplesScrollView;

@property (strong,nonatomic) NSString *searchWord;
@property (strong,nonatomic) NSMutableArray *searchedInfos;
@property  (strong,nonatomic)NSMutableArray *sortingInfo;

@property (strong,nonatomic)NSMutableArray *selectedPersons;
@property (nonatomic)NSInteger selectedButtonXLocation;
@property (nonatomic)NSInteger tag;
@end

@implementation WritingConfirmPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //초기화
    self.searchWord = @"";
    self.searchedInfos = [NSMutableArray arrayWithArray:[UtilityClass callPhoneNumberInfoAtDevice]];
    NSLog(@"%@",self.searchedInfos);
    self.selectedPersons = [[NSMutableArray alloc]init];
    self.selectiedImageView.image = self.groupMainImage;
    
    //처음에 연락처 불러옴
    //텍스트필드델리게이트
    self.groupNameField.delegate = self;
    self.searchPhoneNumberField.delegate =self;
    //테이블뷰 델리게이트
    self.searchedTableView.delegate = self;
    self.searchedTableView.dataSource = self;
    self.searchedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //스크롤뷰세팅
    self.selectedPeoplesScrollView.showsVerticalScrollIndicator=NO;
    self.selectedPeoplesScrollView.showsHorizontalScrollIndicator=YES;
    self.selectedPeoplesScrollView.alwaysBounceVertical=NO;
    self.selectedPeoplesScrollView.alwaysBounceHorizontal=YES;
    [self.selectedPeoplesScrollView setContentSize:CGSizeMake(0,self.selectedPeoplesScrollView.frame.size.height)];
    
    self.selectedPeoplesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _selectedPeoplesScrollView.frame.size.height);
    
    
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.selectedPeoplesScrollView setContentSize:CGSizeMake(_selectedButtonXLocation, _selectedPeoplesScrollView.frame.size.height)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    SearchPhoneNumberTableViewCell *cell =(SearchPhoneNumberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    if(self.selectedPersons.count == 0){
        
        [self.selectedPersons addObject:@{name:cell.searchedNameLabel.text,phoneNumber:cell.searchedPhoneNumberLabel.text}];
    } else {
        
        for (NSDictionary *ckeckedperson in self.selectedPersons) {
            
            if([[ckeckedperson objectForKey:name] isEqualToString:cell.searchedNameLabel.text] &&[[ckeckedperson objectForKey:phoneNumber] isEqualToString:cell.searchedPhoneNumberLabel.text]){
                return ;
            }
            
        }
        [self.selectedPersons addObject:@{name:cell.searchedNameLabel.text,phoneNumber:cell.searchedPhoneNumberLabel.text}];
    }
    for (NSDictionary *person in self.selectedPersons) {
        
        __weak WritingConfirmPageViewController *weakVC = self;
        weakVC.selectedButtonXLocation= 0;
        weakVC.tag =0;
        dispatch_async(dispatch_get_main_queue(), ^{
            CircleButton *personButton= [[CircleButton alloc]initWithFrame:CGRectMake(weakVC.selectedButtonXLocation, 0,self.selectedPeoplesScrollView.frame.size.width/6,self.selectedPeoplesScrollView.frame.size.width/6)];
            
            [personButton setTitle:[person objectForKey:name] forState:UIControlStateNormal];
            
            personButton.tag =self.tag;
            weakVC.tag +=1;
            [personButton addTarget:self action:@selector(touchInSideUpNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.selectedPeoplesScrollView addSubview:personButton];
            self.selectedButtonXLocation +=80;
            
            
            [self viewDidLayoutSubviews];
        });
    }
}
#pragma -mark touchUpInside Method for created NameButton
- (void)touchInSideUpNameButton:(UIButton *)sender{
    UIButton *button = sender;
    for (UIButton *btn in self.selectedPeoplesScrollView.subviews) {
        
        [btn removeFromSuperview];
    }
    
    [self.selectedPersons removeObjectAtIndex:button.tag];
    for (NSDictionary *person in self.selectedPersons) {
        
        __weak WritingConfirmPageViewController *weakVC = self;
        weakVC.selectedButtonXLocation= 0;
        weakVC.tag =0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CircleButton *personButton= [[CircleButton alloc]initWithFrame:CGRectMake(weakVC.selectedButtonXLocation, 0,self.selectedPeoplesScrollView.frame.size.width/6,self.selectedPeoplesScrollView.frame.size.width/6)];
            
            [personButton setTitle:[person objectForKey:name] forState:UIControlStateNormal];
            personButton.titleLabel.textColor= [UIColor whiteColor];
            personButton.tag =self.tag;
            weakVC.tag +=1;
            [personButton addTarget:self action:@selector(touchInSideUpNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.selectedPeoplesScrollView addSubview:personButton];
            self.selectedButtonXLocation +=80;
            [self viewDidLayoutSubviews];
        });
    }
    
}
#pragma -mark searchTableView delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.sortingInfo.count);
    return self.sortingInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchPhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    cell.searchedNameLabel.text = [self.sortingInfo[indexPath.row] objectForKey:name];
    cell.searchedPhoneNumberLabel.text = [self.sortingInfo[indexPath.row] objectForKey:phoneNumber];
    return cell;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 1){
        
        if ([string isEqualToString:@""]) {
            self.searchWord = string;
        } else{
            
            self.searchWord = [textField.text stringByAppendingString:string];
        }
        [self searchForInputedNameString:self.searchWord];
    }
    
    return YES;
}
//들어온 최신글자가  주소록에 있는지 확인
- (void)searchForInputedNameString:(NSString *)inputedString{
    
    self.sortingInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self.searchedInfos) {
        NSString *infoName = [info objectForKey:name];
        
        
        NSString *inputString = [UtilityClass GetUTF8String:inputedString];
        
        NSString *str = [UtilityClass GetUTF8String:infoName];
        
        
        NSRange range = [str rangeOfString:inputString];
        if(range.location !=NSNotFound){
            
            [self.sortingInfo addObject:info];
            
        }
        [self.searchedTableView reloadData];
    }
}

#pragma -mark touchInSide Action Method
- (IBAction)touchInSideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchInSideStoreButton:(id)sender {
   
    CustomIndicateView *indicator = [[CustomIndicateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-40, 50, 50)];
    [self.view addSubview:indicator];
   
    [indicator startAnimating]; // 애니메이션 시작
    __block UIAlertController *alert = [[UIAlertController alloc]init];
    __block UIAlertAction *cancel = [[UIAlertAction alloc]init];
    [NetworkingCenter creatNewGroupWithGroupTitle:self.groupNameField.text groupImage:self.groupMainImage handler:^(NSString *result) {
        
        [indicator stopAnimating];
        
        //그룹아이디가 없다면
        if ([result isKindOfClass:[NSString class]]) {
            
            alert = [UIAlertController alertControllerWithTitle:@"그룹생성 실패" message:@"그룹생성에 실패했습니다.\n다시 생성해주세요" preferredStyle:UIAlertControllerStyleAlert];
            cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
            
        } else {
            
            alert = [UIAlertController alertControllerWithTitle:@"그룹만들기 성공" message:@"그룹이 생성되었습니다." preferredStyle:UIAlertControllerStyleAlert];
            cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            NSInteger groupId = [result integerValue];
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.selectedPersons) {
                
                [array addObject:[dic objectForKey:@"phoneNumber"]];
            }
            if(array.count!=0){
                
                [NetworkingCenter invitePersonsOfGroupForPhoneNumber:array groupID:groupId handler:^(NSString *result) {
                    
                    if([result isEqualToString:@"success"]){
                        
                        NSLog(@"초대성공");
                    }
                }];
            }
        }
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
