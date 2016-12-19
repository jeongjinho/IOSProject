//
//  DetailCollectionViewCell.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 29..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *diaryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCountLabel;
@end
