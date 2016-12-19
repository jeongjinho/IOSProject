//
//  WritingConfirmPageViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 4..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WritingConfirmPageViewController.h"
#import <Contacts/CNContactStore.h>
#import <Contacts//CNContactFetchRequest.h>
#import <Contacts/CNContactFormatter.h>
#import "SearchPhoneNumberTableViewCell.h"
#import "MainColorTextField.h"
#import "CircleButton.h"

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
@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger tag;
@end

@implementation WritingConfirmPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //초기화
    self.searchWord = @"";
    self.searchedInfos = [[NSMutableArray alloc]init];
    self.selectedPersons = [[NSMutableArray alloc]init];
    self.selectiedImageView.image = self.groupMainImage;
   
    //처음에 연락처 불러옴
    [self callPhoneNumberInfoAtDevice];
    //텍스트필드델리게이트
    self.groupNameField.delegate = self;
    self.searchPhoneNumberField.delegate =self;
    //테이블뷰 델리게이트
    self.searchedTableView.delegate = self;
    self.searchedTableView.dataSource = self;
    //스크롤뷰세팅
    self.selectedPeoplesScrollView.showsVerticalScrollIndicator=NO;
    self.selectedPeoplesScrollView.showsHorizontalScrollIndicator=YES;
    self.selectedPeoplesScrollView.alwaysBounceVertical=NO;
    self.selectedPeoplesScrollView.alwaysBounceHorizontal=YES;
    
    self.selectedPeoplesScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _selectedPeoplesScrollView.frame.size.height);

    

}

-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    self.selectedPeoplesScrollView.contentSize = CGSizeMake(self.view.frame.size.width+self.x, _selectedPeoplesScrollView.frame.size.height);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //선택된 셀을 가져와서
    SearchPhoneNumberTableViewCell *cell =(SearchPhoneNumberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //선택된 사람들의 배열에 딕셔너리로 집어넣는다.
    
    //만약 배열에 기존에 선택된 사람이 없다면
    if(self.selectedPersons.count == 0){
    
        [self.selectedPersons addObject:@{name:cell.searchedNameLabel.text,phoneNumber:cell.searchedPhoneNumberLabel.text}];
    } else {
    
        for (NSDictionary *ckeckperson in self.selectedPersons) {
            
            if([[ckeckperson objectForKey:name] isEqualToString:cell.searchedNameLabel.text] &&[[ckeckperson objectForKey:phoneNumber] isEqualToString:cell.searchedPhoneNumberLabel.text]){
                return ;
            }
            
        }
        [self.selectedPersons addObject:@{name:cell.searchedNameLabel.text,phoneNumber:cell.searchedPhoneNumberLabel.text}];
    }
                  for (NSDictionary *person in self.selectedPersons) {
                  
                      __weak WritingConfirmPageViewController *weakVC = self;
                      weakVC.x= 0;
                      weakVC.tag =0;
//---------------------이거 메소드따로뺼수 있으면 뺴자
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIButton *personButton= [[UIButton alloc]init];
                    
                    personButton.frame= CGRectMake(weakVC.x, 0,self.selectedPeoplesScrollView.frame.size.width/6,self.selectedPeoplesScrollView.frame.size.width/6);
                    personButton.layer.cornerRadius = personButton.bounds.size.width/2;
                    personButton.clipsToBounds =YES;
                    
                    personButton.layer.borderColor = mainPurpleColor.CGColor;
                    personButton.layer.borderWidth = 2.0f;
                    [personButton setTitle:[person objectForKey:name] forState:UIControlStateNormal];
                    
                    [personButton setTitleColor:mainPurpleColor forState:UIControlStateNormal];
                  
                    
                    personButton.tag =self.tag;
                    weakVC.tag +=1;
                

                    [personButton addTarget:self action:@selector(touchInSideUpNameButton:) forControlEvents:UIControlEventTouchUpInside];
                    [self.selectedPeoplesScrollView addSubview:personButton];
                    self.x +=80;
                    
              
                    [self viewDidLayoutSubviews];
                });
//----------------------------------------------------------------
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
        weakVC.x= 0;
        weakVC.tag =0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *personButton= [[UIButton alloc]init];
            
            personButton.frame= CGRectMake(weakVC.x, 0,self.selectedPeoplesScrollView.frame.size.width/6,self.selectedPeoplesScrollView.frame.size.width/6);
            personButton.layer.cornerRadius = personButton.bounds.size.width/2;
            personButton.clipsToBounds =YES;
            
            personButton.layer.borderColor = mainPurpleColor.CGColor;
            personButton.layer.borderWidth = 2.0f;
            [personButton setTitle:[person objectForKey:name] forState:UIControlStateNormal];
            
            [personButton setTitleColor:mainPurpleColor forState:UIControlStateNormal];
           
            personButton.tag =self.tag;
            weakVC.tag +=1;
        
            
//------------------스크롤 크기 80인거 조정
            [personButton addTarget:self action:@selector(touchInSideUpNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.selectedPeoplesScrollView addSubview:personButton];
            self.x +=80;
            
//------------------------------
            [self viewDidLayoutSubviews];
            
         
        });
    }

}
#pragma -mark searchTableView delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
            
           //
           
            [self.sortingInfo addObject:info];
            
        }
            [self.searchedTableView reloadData];
         }
   
   
}

//----------유틸리티클래스로 빼내기
- (void)callPhoneNumberInfoAtDevice{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"access denied");
    } else {
      
        CNContactStore *phoneNumberStore = [[CNContactStore alloc]init];
    
        NSMutableArray *keyArray = [[NSMutableArray alloc] initWithObjects:CNContactPhoneNumbersKey,[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], nil];
    
    
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keyArray];
//        CNContactFormatter *fommater =[[CNContactFormatter alloc]init];
//        fommater.style = CNContactFormatterStyleFullName;
        [phoneNumberStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
              
            
            NSString *names =[contact.familyName stringByAppendingString:contact.givenName];
            
            //phoneNumbers 에서 전화번호 가져오기
            [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 NSString *phoneNumbers = [[obj value] stringValue];
                 [self.searchedInfos addObject:@{phoneNumber:phoneNumbers, name:names}];
                 NSLog(@"들어온값 %@ %@",names,phoneNumbers);
            }];
        }];
    
    }
  
}
//-----------------------------------------
#pragma -mark touchInSide Action Method
- (IBAction)touchInSideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchInSideStoreButton:(id)sender {
 //길이조정-------------------------------------------------------
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150,300, 50, 50)];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
//------------------------------------------------------------
    [indicator startAnimating]; // 애니메이션 시작
    __block UIAlertController *alert = [[UIAlertController alloc]init];
    __block UIAlertAction *cancel = [[UIAlertAction alloc]init];
    [NetworkingCenter creatNewGroupWithGroupTitle:self.groupNameField.text groupImage:self.groupMainImage groupImageFileName:self.groupMainImageFileName handler:^(NSString *responseData) {
        
        [indicator stopAnimating];
        
        NSLog(@"응답객체:%@",responseData);
        if ([responseData isKindOfClass:[NSString class]]) {
            
            alert = [UIAlertController alertControllerWithTitle:@"그룹생성 실패" message:@"그룹생성에 실패했습니다.\n다시 생성해주세요" preferredStyle:UIAlertControllerStyleAlert];
            cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
            
        } else {
            
            alert = [UIAlertController alertControllerWithTitle:@"그룹만들기 성공" message:@"그룹이 생성되었습니다." preferredStyle:UIAlertControllerStyleAlert];
            cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];

            
            
            NSInteger groupId = [responseData integerValue];
           
            NSLog(@"dkdlel %ld",groupId);
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.selectedPersons) {
                
                [array addObject:[dic objectForKey:@"phoneNumber"]];
            }
                     if(array.count!=0){
            
                [NetworkingCenter invitePersonsOfGroupForPhoneNumber:array groupID:groupId handler:^(NSString *invitedPerson) {
                    
                    if([invitedPerson isEqualToString:@"success"]){
                        
                        NSLog(@"초대성공");
                    }
                }];
            }
            
            
        }
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }];
        
    
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
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
