//
//  CircleImageView.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 20..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{

    [super awakeFromNib];
    if(self.frame.size.width != self.frame.size.height){
        
        CGFloat  changeheight = self.frame.size.width;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y
                                  , self.frame.size.width,changeheight)];
    }
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    NSLog(@"버전 :%@",[[NSProcessInfo processInfo] operatingSystemVersionString]);
    NSLog(@"%ld",(long)[[NSProcessInfo processInfo] operatingSystemVersion].minorVersion);
    NSLog(@"%@",[[UIDevice currentDevice]systemVersion]);
}
@end
