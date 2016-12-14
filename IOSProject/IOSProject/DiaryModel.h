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





@property NSInteger selectedIndex;
@property NSInteger selectedGroupID;
@property NSString *selectedGroupImageURL;


@property NSMutableArray *selectedPhotos;

+ (instancetype)sharedData;
//groupPage
- (NSDictionary *)groupInfoForIndex:(NSInteger)index;
- (NSString *)groupNameOfGroupListForSelectedIndex;
- (NSInteger)postCountOfGroupListForSelectedIndex;
- (NSInteger)masterOfGroupForSelectedIndex;
- (NSInteger)memberCountOfGroupForSelectedIndex;
//diaryList
- (NSInteger)countOfDiaryList;
- (NSString *)nextDiaryListURLOfDiaryList;
- (NSString *)previusURLOfDiaryList;
- (NSArray *)resultsOfDiaryList;
- (NSInteger)likeCountOfDiaryList;
- (NSInteger)dislikeCountOfDiaryList;
- (NSDictionary *)diaryInResultForIndexPath:(NSInteger)index;
@end
