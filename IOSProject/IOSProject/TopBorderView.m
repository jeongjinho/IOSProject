//
//  TopBorderView.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 20..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "TopBorderView.h"

@implementation TopBorderView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0,1, self.frame.size.width, 0.3f);
    topLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:topLayer];
}

@end
