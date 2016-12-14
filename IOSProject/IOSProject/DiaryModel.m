//
//  DiaryModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DiaryModel.h"
//groupListPage
static NSString *const groupName = @"group_name";
static NSString *const lastUpdated = @"last_updated";
static NSString *const posts = @"posts";
static NSString *const master = @"master";
static NSString *const members = @"members";
static NSString *const groupPostCount = @"post_count";
//detailPage
static NSString *const diaryCount = @"count";
static NSString *const nextURLString = @"next";
static NSString *const previusURLString = @"previous";
static NSString *const results = @"results";
static NSString *const likeCount = @"likes_count";
static NSString *const dislikeCount = @"dislikes_count";
@interface DiaryModel()

@end
@implementation DiaryModel

+ (instancetype)sharedData{
    
    static DiaryModel *datObject = nil;
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
        self.selectedPhotos = [[NSMutableArray alloc]init];
        self.groupList = [[NSMutableArray alloc]init];
        self.diaryList = [[NSMutableDictionary alloc]init];
    }
    return self;
}


#pragma -mark mainPage Group  Mehtods
- (NSDictionary *)groupInfoForIndex:(NSInteger)index{
    return self.groupList[index];
}

- (NSString *)groupNameOfGroupListForSelectedIndex{
  return  [self.groupList[self.selectedIndex] objectForKey:groupName];

}

- (NSString *)lastUpdateOfGroupListForSelectedIndex{

    return  [self.groupList[self.selectedIndex] objectForKey:lastUpdated];
}
- (NSInteger)postCountOfGroupListForSelectedIndex{
    
    return [[self.groupList[self.selectedIndex] objectForKey:diaryCount] integerValue] ;
   }

- (NSInteger)masterOfGroupForSelectedIndex{

    return  [[self.groupList[self.selectedIndex] objectForKey:master] integerValue];
}
- (NSInteger)memberCountOfGroupForSelectedIndex{
   
    NSArray *memberArray = [self.groupList[self.selectedIndex] objectForKey:members];
    return  memberArray.count;
}

#pragma -mark detailPage  Mehtods
- (NSInteger)countOfDiaryList{
    NSLog(@"다이어리 카운트%@",self.diaryList);
    return  [[_diaryList objectForKey:diaryCount] integerValue];
}

- (NSString *)nextDiaryListURLOfDiaryList{
    return  [_diaryList objectForKey:nextURLString];
}

- (NSString *)previusURLOfDiaryList{

    return [_diaryList objectForKey:previusURLString];
}

- (NSArray *)resultsOfDiaryList{

    return  [_diaryList objectForKey:results];
}

- (NSDictionary *)diaryInResultForIndexPath:(NSInteger)index{

 //   NSLog(@"결과 :%@",[_diaryList objectForKey:results][index]);
    return  [_diaryList objectForKey:results][index];
}
- (NSInteger)likeCountOfDiaryList{
    
    return [[_diaryList objectForKey:likeCount] integerValue];
}
- (NSInteger)dislikeCountOfDiaryList{
    
    return [[_diaryList objectForKey:dislikeCount] integerValue];
}
@end
