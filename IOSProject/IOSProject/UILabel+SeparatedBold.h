//
//  UILabel+SeparatedBold.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 20..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(SeparatedBold)
- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
@end
