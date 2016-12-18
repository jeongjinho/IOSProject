//
//  MyInfoModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 19..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "MyInfoModel.h"


@implementation MyInfoModel




+ (instancetype)sharedData{
    
    static MyInfoModel *datObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        datObject  =[[self alloc]init];
        
    });
    return datObject;
}

@end
