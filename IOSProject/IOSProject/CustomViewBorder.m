//
//  CustomViewBorder.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 29..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CustomViewBorder.h"

@implementation CustomViewBorder


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *botomLayer = [CALayer layer];
    botomLayer.frame = CGRectMake(80,self.frame.size.height-1, self.frame.size.width-160, 2.0f);
    botomLayer.backgroundColor = mainPurpleColor.CGColor;
    [self.layer addSublayer:botomLayer];
}


- (void)awakeFromNib{

    [super awakeFromNib];
    
    

}
@end
