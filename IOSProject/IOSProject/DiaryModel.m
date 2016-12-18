//
//  DiaryModel.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 12..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "DiaryModel.h"
//myInfo
static NSString *const email = @"email";
static NSString *const myID = @"id";
static NSString *const profileImage = @"image";
static NSString *const myGroup = @"my_group";
//groupListPage
static NSString *const groupID = @"id";
static NSString *const groupName = @"group_name";
static NSString *const lastUpdated = @"last_updated";
static NSString *const posts = @"posts";
static NSString *const master = @"master";
static NSString *const members = @"members";
static NSString *const groupPostCount = @"post_count";
static NSString *const lastestPosts = @"lastest_posts";
//detailPage
static NSString *const diaryCount = @"count";
static NSString *const nextURLString = @"next";
static NSString *const previusURLString = @"previous";
static NSString *const results = @"results";
static NSString *const likeCount = @"likes_count";
static NSString *const dislikeCount = @"dislikes_count";
//readingPage
static NSString *const pk = @"pk";
static NSString *const content  = @"content";
static NSString *const user = @"user";
static NSString *const uploadedUserId = @"user_pk";
static NSString *const uploadedUserName = @"name";
static NSString *const uploadedUserImage = @"image";
static NSString *const group = @"group";
static NSString *const photos = @"photos";
//static NSString *const likeCount = @"like_count";
static NSString *const liker = @"like";
//static NSString *const dislikesCount = @"dislikes_count";
static NSString *const disliker = @"dislike";
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
        self.diaryInfo = [[NSMutableDictionary alloc]init];
        self.myInfo = [[NSMutableDictionary alloc]init];
        self.likeInfo = [[NSMutableDictionary alloc]init];
        self.dislikeInfo = [[NSMutableDictionary alloc]init];
    }
    return self;
}

#pragma -mark myInfo methods
- (NSString *)emailOfMyInfo{

    return [self.myInfo objectForKey:email];
}

- (NSInteger)myIdOfMyInfo{

    return [[self.myInfo objectForKey:myID] integerValue];
}

- (UIImage *)profileImageOfMyInfo{

    return  [self.myInfo objectForKey:profileImage];
}
#pragma -mark mainPage Group  Methods
- (NSDictionary *)groupInfoForIndex:(NSInteger)index{
    return self.groupList[index];
}

- (NSInteger)groupIdOfGroupListForSelectedIndex{
    return  [[self.groupList[self.selectedIndex] objectForKey:groupID] integerValue];

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
- (void)lastPostOfGroupForSelectedIndex{
    self.seletedDiaryPK = [[[[self.groupList[self.selectedIndex] objectForKey:lastestPosts] firstObject] objectForKey:@"pk"] integerValue];
 

}
#pragma -mark detailPage  Mehtods
- (NSInteger)diaryPkOfDiaryList{

  return [[_diaryList objectForKey:pk] integerValue];
}
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

#pragma -mark readingpage model Method
- (NSInteger)pkOfDiaryInfo{

    return  [[self.diaryInfo objectForKey:pk] integerValue];;
}

- (NSString *)contentOfDiaryInfo{

    return [self.diaryInfo objectForKey:content];
}

- (NSInteger)uploadedUserOfDiaryInfo{

    NSLog(@"%@",[self.diaryInfo objectForKey:uploadedUserId]);
    return  [[[self.diaryInfo objectForKey:user] objectForKey:uploadedUserId] integerValue];
}


- (NSString *)uloadedUserNameOfDiaryInfo{
    return [[self.diaryInfo objectForKey:user] objectForKey:uploadedUserName] ;
    

}

- (NSURL *)uploadedUserImageOfDiaryInfo{

    NSString *urlString =@"";
    if([[[self.diaryInfo objectForKey:user] objectForKey:uploadedUserImage] isKindOfClass:[NSNull class]]){
    
        urlString =@"";
    } else {
    
        urlString = [[self.diaryInfo objectForKey:user] objectForKey:uploadedUserImage];
    }
   
    
    NSURL *url = [NSURL URLWithString:urlString];

    return url;
}
- (NSInteger)groupPkOfDiaryInfo{

    return [[self.diaryInfo objectForKey:group] integerValue];
}

- (NSArray *)photosOfDiaryInfo{

    NSArray *array = [NSArray arrayWithArray:[self.diaryInfo objectForKey:photos]];
    return array;
}

- (NSInteger)likeCountOfDiaryInfo{

    return [[self.diaryInfo objectForKey:likeCount] integerValue];
}

- (NSInteger )likerOfDiaryInfo{

    //NSLog(@"아이디%@",[[self.diaryInfo objectForKey:liker][0] objectForKey:@"user"]);
    NSInteger likerUserID;
    NSArray *array = [NSArray arrayWithArray:[self.diaryInfo objectForKey:liker]];
    if(array.count !=0){
        
    likerUserID =[[[self.diaryInfo objectForKey:liker][0] objectForKey:@"user"] integerValue];
    
    } else {
        likerUserID = 0;
    }
   
   // NSLog(@"어레이정보:%ld",likerUserID);
    return likerUserID;
}

- (NSInteger)dislikeCountOfDiaryInfo{

    return [[self.diaryInfo objectForKey:dislikeCount] integerValue];
}

//- (NSInteger )dislikerOfDiaryInfo{
//    
//    NSInteger dislikerUserID;
//    NSArray *array = [NSArray arrayWithArray:[self.diaryInfo objectForKey:disliker]];
//    if(array.count !=0){
//        
//        dislikerUserID =[[[self.diaryInfo objectForKey:disliker][0] objectForKey:@"user"] integerValue];
//        
//    } else {
//        dislikerUserID = 0;
//    }
//    
//    // NSLog(@"어레이정보:%ld",likerUserID);
//    return dislikerUserID;
//}

//likeInfo;
- (NSInteger)didlikeUserIdOfLikeInfo{
    NSLog(@"라이큰유저:%ld",[[self.likeInfo objectForKey:@"user"] integerValue]);
    return  [[self.likeInfo objectForKey:@"user"] integerValue];
}

- (NSInteger)likeCountOfLikeInfo{
 
    return [[self.likeInfo objectForKey:@"post"] integerValue];
}

//dislikeInfo;
- (NSInteger)didDislikeUserIdOfLikeInfo{
    NSLog(@"디스라이큰유저:%ld",[[self.dislikeInfo objectForKey:@"user"] integerValue]);
    return  [[self.dislikeInfo objectForKey:@"user"] integerValue];
}

- (NSInteger)dislikeCountOfLikeInfo{
    
    return [[self.dislikeInfo objectForKey:@"post"] integerValue];
}
@end
