//
//  WriteDiaryViewController.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 11..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteDiaryViewController.h"

@interface WriteDiaryViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong,nonatomic)UICollectionView *photoCollectionView;
@property (strong,nonatomic)UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
//애니메이션

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomscrollBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foldButtonWidth;
@property (assign,nonatomic)CGFloat keyboardHeight;
@property  (assign,nonatomic)BOOL isFoldingMode;
@property CGFloat tempPhotoWidth;
@property CGFloat tempTop;
@property CGFloat tempBottom;
@property CGFloat tempFoldButtonWidth;
@end

@implementation WriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //두배해주고
    [self initializeComponent];
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showKeyBoardMode:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
}
- (void)showKeyBoardMode:(NSNotification *)notification{
    self.writeButton.userInteractionEnabled = NO;

    if(notification.name == UIKeyboardWillShowNotification){
    
        self.keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        if(self.isFoldingMode==NO){

        } else {
        
            self.tempPhotoWidth = self.photoWidth.constant;
            self.tempTop = self.photoTop.constant;
            self.tempBottom = self.bottomscrollBottom.constant;
            self.tempFoldButtonWidth  =self.foldButtonWidth.constant;
            [UIView animateWithDuration:1.0f animations:^{
                
                self.photoWidth.constant  = -self.view.frame.size.width/2;;
                self.foldButtonWidth.constant= 15;
                self.photoTop.constant = -self.keyboardHeight;
                self.bottomscrollBottom.constant = self.keyboardHeight;
                [self.view layoutIfNeeded];
            }];

        
        }
    }


}

#pragma  -mark touchUpInsideButton methods
//----------Up 붙이기
- (IBAction)touchInSideFoldButton:(id)sender {
    NSLog(@"눌림");
    self.writeButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5f animations:^{
        
        self.photoWidth.constant = self.tempPhotoWidth;
        self.photoTop.constant = self.tempTop;
        self.bottomscrollBottom.constant = self.tempBottom;
        self.foldButtonWidth.constant =self.tempFoldButtonWidth;
        [self.view layoutIfNeeded];
    }];
    self.isFoldingMode = YES;
    [_textView resignFirstResponder];
}
- (void)initializeComponent{
    self.isFoldingMode = YES;
    
    [self.bottomScrollView setContentSize:CGSizeMake(self.view.frame.size.width*2, self.bottomScrollView.frame.size.height)];
    
    UICollectionViewLayout *collectionLayout = [[UICollectionViewLayout alloc]init];
    
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.bottomScrollView.frame.origin.x,0,self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height) collectionViewLayout:collectionLayout];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(self.bottomScrollView.frame.size.width,0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height)];
    [self.bottomScrollView addSubview:self.photoCollectionView];
    [self.bottomScrollView addSubview:self.textView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpInSideSelectButton:(id)sender {
    UIButton *button = sender;
    if([button isKindOfClass:[UIButton class]]){
        switch (button.tag) {
            case 0:
                
                [self.bottomScrollView setContentOffset:CGPointZero animated:YES];
                break;
            case 1:
                
                [self.bottomScrollView setContentOffset:CGPointMake(self.bottomScrollView.contentSize.width/2,0) animated:YES];
                break;
            default:
                break;
        }
    }
}


@end
