//
//  CircleButton.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton



- (void)drawRect:(CGRect)rect {
   
    self.layer.cornerRadius = self.frame.size.width/2;
    self.backgroundColor =mainPurpleColor;
     self.titleLabel.textColor = mainPurpleColor;
    self.layer.borderColor = mainPurpleColor.CGColor;
     self.clipsToBounds = YES;
}
-(void)awakeFromNib{

    [super awakeFromNib];

}

@end
