//
//  CustomIndicateView.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 21..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "CustomIndicateView.h"



//
//  CustomActivityIndicatorView.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 21..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//



@implementation CustomIndicateView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeAttribute];
    }
    return self;
}

- (void)initializeAttribute{
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.color = [UIColor redColor];
    self.hidesWhenStopped = YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


