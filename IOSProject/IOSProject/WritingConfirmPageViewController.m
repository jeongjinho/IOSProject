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

- (void)creatingPeopleLabelOnScrollView{

    
    
}

#pragma -mark searchTableView delegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //선택된 셀을 가져와서
    SearchPhoneNumberTableViewCell *cell =(SearchPhoneNumberTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //선택된 사람들의 배열에 딕셔너리로 집어넣는다.
    [self.selectedPersons addObject:@{name:cell.searchedNameLabel.text,phoneNumber:cell.searchedPhoneNumberLabel.text}];
     __block NSInteger x =0;
    for (NSDictionary *person in self.selectedPersons) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           UIButton *personButton= [[UIButton alloc]init];
            
            personButton.frame= CGRectMake(x, 0,self.selectedPeoplesScrollView.frame.size.width/6,self.selectedPeoplesScrollView.frame.size.width/6);
            personButton.layer.cornerRadius = personButton.bounds.size.width/2;
            personButton.clipsToBounds =YES;
           
            personButton.layer.borderColor = mainPurpleColor.CGColor;
            personButton.layer.borderWidth = 2.0f;
            [personButton setTitle:[person objectForKey:name] forState:UIControlStateNormal];
            
            [personButton setTitleColor:mainPurpleColor forState:UIControlStateNormal];
            NSLog(@"선택된사람%@",[person objectForKey:name]);
            [self.selectedPeoplesScrollView addSubview:personButton];
            x +=100;

        });
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sortingInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SearchPhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    
   
//    NSLog(@"%@", [[self.sortingInfo[indexPath.row] objectForKey:phoneNumber]firstObject].);
    cell.searchedNameLabel.text = [self.sortingInfo[indexPath.row] objectForKey:name];
    cell.searchedPhoneNumberLabel.text = [self.sortingInfo[indexPath.row] objectForKey:phoneNumber];
    return cell;

}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 
    if ([string isEqualToString:@""]) {
        self.searchWord = string;
    } else{
    
        self.searchWord = [textField.text stringByAppendingString:string];
        NSLog(@"조합된 텍스트 :%@",self.searchWord);
    }
    
    
        [self searchForInputedNameString:self.searchWord];

    
    return YES;
}
//들어온 최신글자가  주소록에 있는지 확인
- (void)searchForInputedNameString:(NSString *)inputedString{
    
    self.sortingInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self.searchedInfos) {
        NSString *infoName = [info objectForKey:name];
        
        
        NSString *inputString = [UtilityClass GetUTF8String:inputedString];
        NSLog(@"str :%@",inputString);
        NSString *str = [UtilityClass GetUTF8String:infoName];
        
        NSLog(@"str :%@",str);
        NSRange range = [str rangeOfString:inputString];
        if(range.location !=NSNotFound){
            
           //
           
            [self.sortingInfo addObject:info];
            
        }
            [self.searchedTableView reloadData];
         }
   
   
}


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

#pragma -mark touchInSide Action Method
- (IBAction)touchInSideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchInSideStoreButton:(id)sender {
    
    
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
