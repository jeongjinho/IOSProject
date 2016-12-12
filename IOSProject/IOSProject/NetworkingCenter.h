//
//  NetworkingCenter.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^requestHandler)(NSString *success);
typedef void(^loginHandler)(NSString *token);
typedef void(^createNewGroupHandler)(NSString *responseData);
typedef void(^groupListHandler)(NSString *groupList);
typedef void(^postDiaryHandler)(NSString *postDiary);
@interface NetworkingCenter : NSObject

+ (void)showGroupList:(groupListHandler)handler;

+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image groupImageFileName:(NSString *)fileName handler:(createNewGroupHandler)handler;

+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)password loginHandler:(loginHandler)loginHandler;

+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image requestHandler:(requestHandler)handlers;

+ (void)postDiaryWithGroupId:(NSInteger)groupId postText:(NSString *)postText selectedImages:(NSArray *)images postDiaryHander:(postDiaryHandler)handler;
@end
