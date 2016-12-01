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
static NSString *const signUpURLString = @"https://glue-dev.muse9.net/member/signup/";
static NSString  *const emailString = @"email";
static NSString  *const nameString = @"name";
static NSString  *const passwordString = @"password";
static NSString  *const phoneNumberString = @"phone_number";
static NSString  *const imageString = @"image";
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
+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)passwords{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:loginURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *emailAddressData = [emailAddress dataUsingEncoding:NSUTF8StringEncoding];
        NSData *passwordData =[passwords dataUsingEncoding:NSUTF8StringEncoding];
        //append string
        [formData appendPartWithFormData:emailAddressData name:emailString];
        [formData appendPartWithFormData:passwordData name:passwordString];
        
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

+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image{
    
//    NSData *emailAddressData = [emailAddress dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *passwordData =[password dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSData *phoneNumnerData = [phoneNumber dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *nameData =[name dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *imageData =nil;
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    NSLog(@"email : %@ ",emailAddress);
    NSLog(@"phoneNumber : %@",password);
    [bodyParams setObject:emailAddress
                   forKey:emailString];
    
    [bodyParams setObject:phoneNumber
                   forKey:phoneNumberString];

    [bodyParams setObject:password
                   forKey:passwordString];
    
    [bodyParams setObject:name
                   forKey:nameString];
    
    NSLog(@"bodyParams  :%@", bodyParams);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:signUpURLString parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // NSData *imageData =nil;
        //append string
//      [formData appendPartWithFormData:emailAddressData name:emailString];
//        [formData appendPartWithFormData:passwordData name:passwordString];
//        [formData appendPartWithFormData:phoneNumnerData name:phoneNumberString];
//        [formData appendPartWithFormData:nameData name:nameString];
       // [formData appendPartWithFormData:imageData  name:imageString];

    } error:nil];
    
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
                          NSLog(@"실패`````");
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          NSLog(@"networking success!");
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              
                          });
                      }
                  }];
    
    [uploadTask resume];
    
}
@end
