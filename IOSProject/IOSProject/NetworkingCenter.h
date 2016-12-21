//
//  NetworkingCenter.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^requestHandler)(NSString *result);
typedef void(^createCommentHandler)(NSDictionary *createCommentHandler);

@interface NetworkingCenter : NSObject
#pragma -mark GroupNetworking
+ (void)showGroupList:(requestHandler)handler;

+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image  handler:(requestHandler)handler;

+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)password loginHandler:(requestHandler)loginHandler;

+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image requestHandler:(requestHandler)handlers;

+ (void)postDiaryWithGroupId:(NSInteger)groupId postText:(NSString *)postText selectedImages:(NSArray *)images postDiaryHander:(requestHandler)handler;

+ (void)diaryListForGroupID:(NSInteger)groupID handler:(requestHandler)handler;

+ (void)diaryListForNextURL:(NSString *)nextURL handler:(requestHandler)handler;

+ (void)invitePersonsOfGroupForPhoneNumber:(NSArray *)selectedPersons groupID:(NSInteger)groupID handler:(requestHandler)handler;

+ (void)diaryForPostID:(NSInteger)diaryID handler:(requestHandler)handler;

+ (void)myInfoAtApp:(requestHandler)handler;
+ (void)deleteFordiaryID:(NSInteger)diaryID handler:(requestHandler)handler;

+ (void)likeForDiaryID:(NSInteger)diaryID handler:(requestHandler)handler;

+ (void)dislikeForDiaryID:(NSInteger)diaryID handler:(requestHandler)handler;

+ (void)deleteGroupForGroupID:(NSInteger)groupID handler:(requestHandler)handler;

+ (void)modifyContentForDiaryID:(NSInteger)diaryID content:(NSString *)content handler:(requestHandler)handler;

+ (void)createCommentsForDiaryID:(NSInteger)diaryID content:(NSString *)comment handler:(createCommentHandler)handler;

+ (void)deleteCommentsForCommentID:(NSInteger)commentID handler:(requestHandler)handler;
@end
