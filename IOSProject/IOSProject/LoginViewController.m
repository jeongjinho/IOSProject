//
//  LoginViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "KeychainItemWrapper.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
static NSString *const emailText =  @"emailTextField.text";
static NSString *const passwordText = @"passwordTextField.text";

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic) UITapGestureRecognizer *windowTap;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    
    
//    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"keyChain" accessGroup:nil];
//    [keyChain setObject:iden forKey:kSecAttrAccount];
//    NSString *userId = [keyChain objectForKey:(__bridge NSString *)kSecAttrAccount];
//    NSLog(@"key chain :%@",[keyChain objectForKey:(__bridge NSString *)kSecAttrAccount]);
//    NSLog(@"유저 id : %@",userId);
    
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.hidden = YES;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    //유저텍스트필드 히든
    self.passwordTextField.secureTextEntry = YES;
    
    //observing
    [self addObserver:self forKeyPath:emailText options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:passwordText options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //observing에 따른 로그인 화면변화
    self.loginButton.userInteractionEnabled =NO;
    self.loginButton.layer.opacity = 0.1f;

    
    self.windowTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    
    [self.view addGestureRecognizer:self.windowTap];
}

-(void)resignKeyboard:(UITapGestureRecognizer*)tap{

    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];


}
#pragma -mark login textField
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{


    if ([keyPath isEqualToString:emailText]) {
        NSLog(@"The email is changed.");
        
    }
    
    if ([keyPath isEqualToString:passwordText]) {
      
        
        if(self.emailTextField.text.length  >=5 && self.passwordTextField.text.length >= 8){
            self.loginButton.layer.opacity = 1.0f;
            self.loginButton.userInteractionEnabled = YES;
            
        } else{
            self.loginButton.userInteractionEnabled =NO;
            self.loginButton.layer.opacity = 0.1f;

        }
        
    }

}
#pragma -mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //아이디를 쓰고 리턴을 눌렀을때idTextField tag = 0 , passwordTextField tag = 1
    switch (textField.tag) {
        case 0:
            [self.passwordTextField becomeFirstResponder];
            break;
            
        case 1:
            [self.passwordTextField resignFirstResponder];
            break;
            
        default:
            break;
    }
    
    return YES;
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
