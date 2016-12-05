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
    self.selectiedImageView.image = self.groupMainImage;
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
    
    
   
//    NSLog(@"%@", [[self.sortingInfo[indexPath.row] objectForKey:phoneNumber]firstObject].);
    cell.textLabel.text = [self.sortingInfo[indexPath.row] objectForKey:name];
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
            
            
        [self.searchedInfos  addObject:@{phoneNumber:contact.phoneNumbers, name:names}];
        
            NSLog(@"들어온값 %@",[self.searchedInfos objectAtIndex:0]);
           
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
