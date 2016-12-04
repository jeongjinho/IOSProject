//
//  MainColorTextField.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 4..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "MainColorTextField.h"

@implementation MainColorTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1.5, self.frame.size.width, 1.5f);
    
    [[UIColor blueColor] setFill];
    
    
    emailBorder.backgroundColor = mainPurpleColor.CGColor;
    [self.layer addSublayer:emailBorder];
    
    
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];

}


@end
