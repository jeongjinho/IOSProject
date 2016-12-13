//
//  DiaryModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DiaryModel.h"
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

#pragma -mark detailPage  Mehtods
- (NSInteger)countOfDiaryList{
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
