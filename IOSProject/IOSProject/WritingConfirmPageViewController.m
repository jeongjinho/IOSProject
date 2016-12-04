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

#import "MainColorTextField.h"


static NSString *const name = @"name";
static NSString *const phoneNumber = @"phoneNumber";
@interface WritingConfirmPageViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *selectiedImageView;
@property (weak, nonatomic) IBOutlet MainColorTextField *groupNameField;
@property (weak, nonatomic) IBOutlet MainColorTextField *searchPhoneNumberField;
@property (weak, nonatomic) IBOutlet UITableView *searchedTableView;
@property (strong,nonatomic) NSString *searchWord;
@property (strong,nonatomic) NSMutableArray *searchedInfos;
@property  (strong,nonatomic)NSMutableArray *sortingInfo;

@end

@implementation WritingConfirmPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchWord = @"";
    self.searchedInfos = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    [self callPhoneNumberInfoAtDevice];
    self.groupNameField.delegate = self;
    self.searchPhoneNumberField.delegate =self;
    self.searchedTableView.delegate = self;
    self.searchedTableView.dataSource = self;
}
#pragma -mark searchTableView delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.sortingInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.sortingInfo[indexPath.row] objectForKey:name];
    return cell;

}

- (NSString *)GetUTF8String:(NSString *)str {
    NSArray *cho = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@" ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSArray *jung = [[NSArray alloc] initWithObjects:@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@" ㅙ",@"ㅚ",@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",@"ㅡ",@"ㅢ",@"ㅣ",nil];
    NSArray *jong = [[NSArray alloc] initWithObjects:@"",@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@" ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
    
    NSString *returnText = @"";
    for (int i=0;i<[str length];i++) {
        NSInteger code = [str characterAtIndex:i];
        if (code >= 44032 && code <= 55203) { // 한글영역에 대해서만 처리
            NSInteger UniCode = code - 44032; // 한글 시작영역을 제거
            NSInteger choIndex = UniCode/21/28; // 초성
            NSInteger jungIndex = UniCode%(21*28)/28; // 중성
            NSInteger jongIndex = UniCode%28; // 종성
            
            returnText = [NSString stringWithFormat:@"%@%@%@%@", returnText, [cho objectAtIndex:choIndex], [jung objectAtIndex:jungIndex], [jong objectAtIndex:jongIndex]];
        }
    }
    return returnText;
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

- (void)searchForInputedNameString:(NSString *)inputedString{
    
    self.sortingInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *info in self.searchedInfos) {
        NSString *infoName = [info objectForKey:name];
        
        NSRange range = [infoName rangeOfString:inputedString];
        if(range.location !=NSNotFound){
            
            NSLog(@"이름 :%@",infoName);
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
            NSLog(@"조합된이름 :%@",names);
     
            
        [self.searchedInfos  addObject:@{phoneNumber:contact.phoneNumbers, name:names}];
        
            NSLog(@"들어온값 %@",[self.searchedInfos objectAtIndex:0]);
           
        }];
    
    }
  
    
}

#pragma -mark touchInSide Action Method
- (IBAction)touchInSideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
