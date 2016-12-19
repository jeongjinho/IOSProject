//
//  MyInfoModel.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 19..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyInfoModel : NSObject

@property NSMutableDictionary *myInfo;
+ (instancetype)sharedData;
- (NSString *)emailOfMyInfo;
- (NSInteger)myIdOfMyInfo;
- (UIImage *)profileImageOfMyInfo;
@end
