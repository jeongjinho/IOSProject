//
//  BottomLineLayout.m
//  IOSProject
//
//  Created by Yang on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "BottomLineLayout.h"

@implementation BottomLineLayout

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:emailBorder];
    
    [[UIColor blueColor] setFill];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)bottomLineStyleTextFiled{
    
    
    
    
}


@end
