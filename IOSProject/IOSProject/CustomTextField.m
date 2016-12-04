//
//  CustomTextField.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    
    [[UIColor blueColor] setFill];
    
    
        emailBorder.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:emailBorder];
   
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}


@end
