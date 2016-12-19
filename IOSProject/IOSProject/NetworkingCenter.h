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
typedef void(^diaryListHandler)(NSString *diaryList);
typedef void(^nextPageHandler)(NSString *nextPage);
typedef void(^invitePersonsHandler)(NSString *invitedPerson);
typedef void(^diayInfoHandler)(NSString *diaryInfo);
typedef void(^myInfoHandler)(NSString *myInfo);
typedef void(^deleteHandler)(NSString *deleteDiary);
typedef void(^likeHandler)(NSString *likeHandler);
typedef void(^dislikeHandler)(NSString *dislikeHandler);
typedef void(^deleteGroupHandler)(NSString *deleteGroupHandler);
typedef void(^modifiedDiaryHandler)(NSString *modifiedContent);
typedef void(^createCommentHandler)(NSDictionary *createCommentHandler);
typedef void(^deleteCommentHandler)(NSString *deleteCommentHandler);
@interface NetworkingCenter : NSObject

+ (void)showGroupList:(groupListHandler)handler;

+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image groupImageFileName:(NSString *)fileName handler:(createNewGroupHandler)handler;

+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)password loginHandler:(loginHandler)loginHandler;

+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image requestHandler:(requestHandler)handlers;

+ (void)postDiaryWithGroupId:(NSInteger)groupId postText:(NSString *)postText selectedImages:(NSArray *)images postDiaryHander:(postDiaryHandler)handler;

+ (void)diaryListForGroupID:(NSInteger)groupID handler:(diaryListHandler)handler;
+ (void)diaryListForNextURL:(NSString *)nextURL handler:(nextPageHandler)handler;

+ (void)invitePersonsOfGroupForPhoneNumber:(NSArray *)selectedPersons groupID:(NSInteger)groupID handler:(invitePersonsHandler)handler;

+ (void)diaryForPostID:(NSInteger)diaryID handler:(diayInfoHandler)handler;

+ (void)myInfoAtApp:(myInfoHandler)handler;
+ (void)deleteFordiaryID:(NSInteger)diaryID handler:(deleteHandler)handler;
+ (void)likeForDiaryID:(NSInteger)diaryID handler:(likeHandler)handler;
+ (void)dislikeForDiaryID:(NSInteger)diaryID handler:(dislikeHandler)handler;
+ (void)deleteGroupForGroupID:(NSInteger)groupID handler:(deleteGroupHandler)handler;
+ (void)modifyContentForDiaryID:(NSInteger)diaryID content:(NSString *)content handler:(modifiedDiaryHandler)handler;
+ (void)createCommentsForDiaryID:(NSInteger)diaryID content:(NSString *)comment handler:(createCommentHandler)handler;
+ (void)deleteCommentsForCommentID:(NSInteger)commentID handler:(deleteCommentHandler)handler;
@end
