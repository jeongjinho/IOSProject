//
//  CommentBorder.m
//  IOSProject
//
//  Created by Yang on 2016. 12. 2..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CommentBorder.h"

@implementation CommentBorder


- (void)drawRect:(CGRect)rect {
   
    //comment Border
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:emailBorder];
    
    [[UIColor blueColor] setFill];
    
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}


@end
