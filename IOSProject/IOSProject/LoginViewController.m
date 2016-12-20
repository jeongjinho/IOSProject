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
#import <FBSDKCoreKit.h>

static NSString *const emailText =  @"emailTextField.text";
static NSString *const passwordText = @"passwordTextField.text";

@interface LoginViewController ()<UITextFieldDelegate,FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic) UITapGestureRecognizer *windowTap;
@property NSString *tokenValue;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef DEBUG
    _emailTextField.text = @"010394463765";
    _passwordTextField.text = @"123456789012345qw!@";
#endif
    
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
    //탭
    self.windowTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    
    [self.view addGestureRecognizer:self.windowTap];
    
}


#pragma -mark touchInside Login Button
- (IBAction)touchInSideLoginButton:(id)sender {
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"glue" accessGroup:nil];
    NSString *keychainToken = [keychain objectForKey:(id)kSecAttrAccount];
    
    [NetworkingCenter loginWithEmail:self.emailTextField.text password:self.passwordTextField.text loginHandler:^(NSString *result) {
        
        self.tokenValue = result;
        NSLog(@"토큰 :%@ ", self.tokenValue);
         UITabBarController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
        if([self.tokenValue isEqualToString:@"fail"]){
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"로그인 실패" message:@"로그인이 실패 되었습니다.\n아이디와 비밀번호를 확인해주세요." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
            self.emailTextField.text = @"";
            self.passwordTextField.text = @"";
            [alert addAction:cancle];
            [self presentViewController:alert animated:YES completion:nil];

        }
        else if([keychainToken isEqualToString:self.tokenValue]){
            
            NSLog(@"전에 로그인한적있음");
            [keychain setObject:self.tokenValue forKey:(id)kSecAttrAccount];
            [self presentViewController:mainVC animated:YES completion:nil];
            [NetworkingCenter myInfoAtApp:nil];
        } else {
               NSLog(@"여기에 처음로그인");
            [keychain setObject:self.tokenValue forKey:(id)kSecAttrAccount];
            [self presentViewController:mainVC animated:YES completion:nil];
            [NetworkingCenter myInfoAtApp:nil];
        }
        
    }];
        
   
    

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
