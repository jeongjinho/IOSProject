//
//  DataCenter.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject
@property NSMutableArray *groupDataList;
//------------------MainGroupPageProperty
@property (strong,nonatomic) NSString *groupTitle;
@property  NSInteger selectedGroupId;
+ (instancetype)sharedData;

//==================valueFor GroupPage


@end
