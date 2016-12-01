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
static NSString *const loginURLString = @"http://dummy-dev.ap-northeast-2.elasticbeanstalk.com/group/";
static NSString *const user_emailAddress = @"user_emailAddress";
static NSString *const user_password = @"user_password";
@implementation NetworkingCenter

+ (instancetype)sharedNetwork{
    
    static NetworkingCenter *networkingObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        networkingObject  =[[self alloc]init];
        
    });
    return networkingObject;
    
}
#pragma -mark groupPage method
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

#pragma -mark login method
+ (void)LoginWithEmail:(NSString *)emailAddress password:(NSString *)password{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:loginURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *emailAddressData = [emailAddress dataUsingEncoding:NSUTF8StringEncoding];
        NSData *passwordData =[password dataUsingEncoding:NSUTF8StringEncoding];
        //append string
        [formData appendPartWithFormData:emailAddressData name:user_emailAddress];
        [formData appendPartWithFormData:passwordData name:user_password];
        
    } error:nil];
    //세션생성
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                         
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}


@end
