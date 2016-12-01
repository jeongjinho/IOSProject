//
//  NetworkingCenter.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "NetworkingCenter.h"
#import <AFNetworking.h>
static NSString *const groupURLString  = @"http://dummy-dev.ap-northeast-2.elasticbeanstalk.com/group/";

@implementation NetworkingCenter

+ (instancetype)sharedNetwork{
    
    static NetworkingCenter *networkingObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        networkingObject  =[[self alloc]init];
        
    });
    return networkingObject;
    
}

+ (void)requestGroupPageDataList{
    NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *networkingManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:groupURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"POST"];
    [request setURL:URL];
    NSURLSessionDataTask *dataTask = [networkingManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *notificationName;
        if(error){
            
            NSLog(@" error : %@",error);
        } else{
            
            NSLog(@" response: %@ ,reponseObject: %@",response,responseObject);
            if(responseObject){
                notificationName = GroupListResponseNotification;
                
                NSMutableArray *dataArray = responseObject;
                [DataCenter sharedData].GroupDataList = dataArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                        object:nil];
               
                });
                
            }
        }
    }];
    [dataTask resume];
}


@end
