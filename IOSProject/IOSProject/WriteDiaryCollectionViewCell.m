//
//  WriteDiaryCollectionViewCell.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 11..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "WriteDiaryCollectionViewCell.h"

@implementation WriteDiaryCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
        _label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _label.backgroundColor = [UIColor blackColor];
        _label.layer.opacity = 0.65f;
        _label.hidden =YES;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.text = @"V";
        
        [self.imageView addSubview:_label];
    }
    return self;
}

-(void)prepareForReuse {
    
}
@end
