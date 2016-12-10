//
//  DataCenter.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject
@property NSArray *groupDataList;
//------------------MainGroupPageProperty
@property (strong,nonatomic) NSString *groupTitle;

+ (instancetype)sharedData;

//==================valueFor GroupPage
- (NSDictionary *)groupInfoForIndex:(NSInteger)index;

@end
