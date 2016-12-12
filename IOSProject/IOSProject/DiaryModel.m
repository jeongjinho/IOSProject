//
//  DiaryModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DiaryModel.h"

@implementation DiaryModel

+ (instancetype)sharedData{
    
    static DiaryModel *datObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        datObject  =[[self alloc]init];
        
    });
    return datObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedPhotos = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
