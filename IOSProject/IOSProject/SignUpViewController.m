//
//  SignUpViewController.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "SignUpViewController.h"
#import "BottomLineLayout.h"

@interface SignUpViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet BottomLineLayout *emailText;
@property (weak, nonatomic) IBOutlet BottomLineLayout *pwText;
@property (weak, nonatomic) IBOutlet BottomLineLayout *confirmText;
@property (weak, nonatomic) IBOutlet BottomLineLayout *phoneText;
@property (weak, nonatomic) IBOutlet BottomLineLayout *nameText;
@property (strong, nonatomic) IBOutlet BottomLineLayout *CertificationText;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneCertification;
@property (strong, nonatomic) IBOutlet UIButton *phoneConfirm;
@property (weak, nonatomic) IBOutlet UILabel *confirmLb;


@end


@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //id TextField ,passwordTextField 키보드 델리게이트
    self.emailText.delegate = self;
    self.pwText.delegate = self;
    self.confirmText.delegate = self;
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    
}

#pragma mark - textFeild Opction




#pragma mark - Button Action

//비밀번호 틀릴시 뷰 에 띄우기
- (IBAction)setSignupBtn:(id)sender
{
    if (self.pwText.text != self.confirmText.text) {
        NSString *text = [NSString stringWithFormat:@"비밀번호가 틀립니다."];
        [self.confirmLb setText:text];
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

