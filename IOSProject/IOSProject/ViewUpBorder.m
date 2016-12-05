
//
//  ViewUpBorder.m
//  IOSProject
//
//  Created by Yang on 2016. 12. 2..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "ViewUpBorder.h"

@implementation ViewUpBorder


- (void)drawRect:(CGRect)rect {
    
//    CALayer *border = [CALayer layer];
//    CGFloat borderWidth = 2;
//    border.borderColor = [UIColor grayColor].CGColor;
//    border.frame = CGRectMake(borderWidth, borderWidth, self.frame.size.width+30, self.frame.size.height);
//    border.borderWidth = borderWidth;
//    [self.layer addSublayer:border];
//    self.layer.masksToBounds = YES;
    
    //Commnet View Up Boreder
    CALayer *viewBorder = [CALayer layer];
    viewBorder.frame = CGRectMake(0, 0 , self.frame.size.width, 1.0f);
    viewBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:viewBorder];
    
    [[UIColor blueColor] setFill];

    
}


@end
