//
//  CircleButton.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self butttonIntialize];
    }
    return self;
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    [super drawLayer:layer inContext:ctx];
    
    
}

- (void)butttonIntialize{
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.titleLabel.textColor = [UIColor whiteColor];
   self.layer.borderColor = mainPurpleColor.CGColor;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.borderColor = mainPurpleColor.CGColor;
    self.layer.borderWidth = 2.0f;
    self.backgroundColor = mainPurpleColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
