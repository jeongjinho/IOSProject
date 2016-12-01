//
//  NetworkingCenter.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingCenter : NSObject

+ (void)requestGroupPageDataList;
+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image;
@end
