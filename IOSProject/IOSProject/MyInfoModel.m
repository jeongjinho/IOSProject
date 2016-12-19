//
//  MyInfoModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 19..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "MyInfoModel.h"
static NSString *const email = @"email";
static NSString *const myID = @"id";
static NSString *const profileImage = @"image";
static NSString *const myGroup = @"my_group";

@implementation MyInfoModel

+ (instancetype)sharedData{
    
    static MyInfoModel *datObject = nil;
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
        
    self.myInfo = [[NSMutableDictionary alloc]init];
        
        
    }
    return self;
}

- (NSString *)emailOfMyInfo{
    
    return [self.myInfo objectForKey:email];
}

- (NSInteger)myIdOfMyInfo{
    
    return [[self.myInfo objectForKey:myID] integerValue];
}

- (UIImage *)profileImageOfMyInfo{
    
    return  [self.myInfo objectForKey:profileImage];
}
@end
