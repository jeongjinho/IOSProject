//
//  DiaryModel.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject

@property NSMutableArray *groupList;

@property NSMutableDictionary *diaryList;

@property NSMutableDictionary *diaryInfo;

@property NSMutableDictionary *likeInfo;
@property NSMutableDictionary *dislikeInfo;

//userInfo
//@property NSMutableDictionary *myInfo;

//groupList
@property NSInteger selectedIndex;
@property NSInteger selectedGroupID;
@property NSString *selectedGroupImageURL;
@property NSInteger seletedDiaryPK;


//invite
@property NSInteger createNewGroupId;



@property NSMutableArray *selectedPhotos;


//comment
@property NSMutableArray *commentsInfo;
+ (instancetype)sharedData;
//myInfo
//- (NSString *)emailOfMyInfo;
//- (NSInteger)myIdOfMyInfo;
//- (UIImage *)profileImageOfMyInfo;
//groupPage
- (NSInteger)groupIdOfGroupListForSelectedIndex;
- (NSDictionary *)groupInfoForIndex:(NSInteger)index;
- (NSString *)groupNameOfGroupListForSelectedIndex;
- (NSInteger)postCountOfGroupListForSelectedIndex;
- (NSInteger)masterOfGroupForSelectedIndex;
- (NSInteger)memberCountOfGroupForSelectedIndex;
- (void)lastPostOfGroupForSelectedIndex;
//diaryList
- (NSInteger)diaryPkOfDiaryList;
- (NSInteger)countOfDiaryList;
- (NSString *)nextDiaryListURLOfDiaryList;
- (NSString *)previusURLOfDiaryList;
- (NSArray *)resultsOfDiaryList;
- (NSInteger)likeCountAtIndexOfDiaryList:(NSInteger)index;
- (NSInteger)dislikeCountAtIndexOfDiaryList:(NSInteger)index;
- (NSDictionary *)diaryInResultForIndexPath:(NSInteger)index;
//diarInfo
- (NSInteger)pkOfDiaryInfo;
- (NSString *)contentOfDiaryInfo;
- (NSInteger)uploadedUserOfDiaryInfo;
- (NSString *)uloadedUserNameOfDiaryInfo;
- (NSURL *)uploadedUserImageOfDiaryInfo;
- (NSInteger)groupPkOfDiaryInfo;
- (NSArray *)photosOfDiaryInfo;
- (NSInteger)likeCountOfDiaryInfo;
- (NSInteger )likerOfDiaryInfo;
- (NSInteger)dislikeCountOfDiaryInfo;
- (NSInteger )dislikerOfDiaryInfo;
- (void)commentsOfDiaryInfo;

//likeInfo
- (BOOL)didlikeOfLikeInfo;
- (NSInteger)likeCountOfLikeInfo;
- (BOOL)didDislikeOfLikeInfo;
- (NSInteger)dislikeCountOfLikeInfo;

//comentsInfo
- (NSString *)contentOfCommentsInfo:(NSInteger)index;
- (NSURL *)commentUserImageOfCommentsInfo:(NSInteger)index;
- (NSString *)commentUserNameOfCommentsInfo:(NSInteger)index;
- (NSInteger)commentUserPkOfCommentsInfo:(NSInteger)index;
@end
