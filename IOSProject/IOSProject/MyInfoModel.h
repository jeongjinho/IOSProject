//
//  MyInfoModel.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 19..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const email = @"email";
static NSString *const myID = @"id";
static NSString *const profileImage = @"image";
static NSString *const myGroup = @"my_group";

@interface MyInfoModel : NSObject

@property NSMutableDictionary *myInfo;
+ (instancetype)sharedData;
@end
