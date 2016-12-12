//
//  DiaryModel.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject

@property NSMutableArray *selectedPhotos;

+ (instancetype)sharedData;
@end
