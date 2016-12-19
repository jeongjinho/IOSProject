//
//  SignUpViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomTextField.h"

@interface SignUpViewController ()<UITextFieldDelegate>


//@property (weak, nonatomic) IBOutlet CustomTextField *idText;
@property (weak, nonatomic) IBOutlet CustomTextField *pwText;
@property (weak, nonatomic) IBOutlet CustomTextField *confirmText;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneText;
@property (weak, nonatomic) IBOutlet CustomTextField *nameText;
@property (strong, nonatomic) IBOutlet CustomTextField *CertificationText;
@property (weak, nonatomic) IBOutlet CustomTextField *emailText;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneCertification;
@property (strong, nonatomic) IBOutlet UIButton *phoneConfirm;
@property (weak, nonatomic) IBOutlet UILabel *confirmLb;


@end


@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //id TextField ,passwordTextField 키보드 델리게이트
   // self.idText.delegate = self;
    self.pwText.delegate = self;
    self.confirmText.delegate = self;
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    self.CertificationText.delegate = self;
    self.emailText.delegate = self;
    self.emailText.attributedPlaceholder =[[NSAttributedString alloc]
                                        initWithString:@"이메일형식에 맞게 입력해주세요"];
    
    
}

#pragma mark - textFeild Opction




#pragma mark - Button Action

//비밀번호 틀릴시 뷰 에 띄우기
- (IBAction)setSignupBtn:(id)sender
{
  
    if (![self.pwText.text isEqualToString:self.confirmText.text]) {
        NSString *text = [NSString stringWithFormat:@"비밀번호를 다시 입력해 주세요"];
        self.pwText.text = nil;
        self.confirmText.text = nil;
        UIColor *color = [UIColor redColor];
        self.pwText.attributedPlaceholder =[[NSAttributedString alloc]
         initWithString:text
         attributes:@{NSForegroundColorAttributeName:color}];
        
    }
//    if (self.idText.text.length <= 5 && self.idText.text.stringByRemovingPercentEncoding && " " )
//    {
//        self.idText.text = nil;
//        UIColor *color = [UIColor redColor];
//        self.idText.attributedPlaceholder =[[NSAttributedString alloc]
//         initWithString:@"5글자이상 , 특수문자는 쓰지 마세요."
//         attributes:@{NSForegroundColorAttributeName:color}];
    
 //   }
    if (self.pwText.text.length <=8 && self.confirmText.text.length <=8)
    {
        NSString *Warring = [NSString stringWithFormat:@"8글자 이상 작성해 주세요."];
        self.pwText.text = nil;
        UIColor *color = [UIColor redColor];
        self.pwText.attributedPlaceholder =[[NSAttributedString alloc]
                                            initWithString:Warring
                                            attributes:@{NSForegroundColorAttributeName:color}];
    }
  
    UIImage *profile = [UIImage imageNamed:@"user"];
    
    NSData *prfileData = UIImageJPEGRepresentation(profile,0.1);
 [NetworkingCenter singUpWithPhoneNumber:self.phoneText.text password:self.pwText.text name:self.nameText.text emailAddress:self.emailText.text image:prfileData requestHandler:^(NSString *success) {
  
     if([success isEqualToString:@"success"]){
     
         NSLog(@"success back to login");
         [self.navigationController popViewControllerAnimated:YES];
     } else {
     
         NSLog(@"에러");
     }
     
    
 }];
}

- (IBAction)touchInSideMainButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - etcOption

//키보드 내리기
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

