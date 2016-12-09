//
//  NetworkingCenter.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 11. 28..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "NetworkingCenter.h"
#import <AFNetworking.h>

static NSString *const succcess  = @"success";
static NSString *const fail = @"fail";
static NSString *const authorization = @"Authorization";

static NSString *const createNewGroupURLString  = @"https://glue-dev.muse9.net/group/group_list/";
static NSString *const signUpURLString = @"https://glue-dev.muse9.net/member/signup/";
static NSString *const loginURLString = @"https://glue-dev.muse9.net/member/login/";

//SignUp
static NSString  *const emailString = @"email";
static NSString  *const nameString = @"name";
static NSString  *const passwordString = @"password";
static NSString  *const phoneNumberString = @"phone_number";
static NSString  *const imageString = @"image";

//CreateGroup
static NSString *const groupName = @"group_name";
static NSString *const groupImage = @"group_image";

@implementation NetworkingCenter

+ (instancetype)sharedNetwork{
    
    static NetworkingCenter *networkingObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        networkingObject  =[[self alloc]init];
        
    });
    return networkingObject;
    
}
#pragma -mark create Group method
+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image handler:(createNewGroupHandler)handler{
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:name forKey:groupName];

   NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:createNewGroupURLString parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:groupImage
                                fileName:@"image.png"
                                mimeType:@"image/png"];
    } error:nil];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    NSLog(@"requestHeader :%@",request.allHTTPHeaderFields);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                 
                    }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                       
                          NSLog(@"Error: %@", error);
                          handler(fail);
                      } else {
                         
                          NSLog(@"응답객체 :%@",responseObject);
                          handler(succcess);
                        }
                  }];
    
    [uploadTask resume];
}

#pragma -mark login method
+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)password loginHandler:(loginHandler)loginHandler{
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    
    //나중에 이메일로 바꿔야함 phoneNumberString ->emailString
    [bodyParams setObject:emailAddress
                   forKey:phoneNumberString];
    [bodyParams setObject:password
                   forKey:passwordString];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:loginURLString parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                    }
                  
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      NSString *loginToken = [responseObject objectForKey:@"token"];
                      NSLog(@" token %@",loginToken);
                      if (error) {
                          
                          loginHandler(fail);
                      } else {
                            loginHandler(loginToken);
                         
                        }
                  }];
    
    [uploadTask resume];
}

+ (void)singUpWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password name:(NSString *)name emailAddress:(NSString *)emailAddress image:(NSData *)image requestHandler:(requestHandler)handlers {
    
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
        
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          NSLog(@"실패`````");
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          NSLog(@"networking success!");
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              handlers(succcess);
                          });
                      }
                  }];
    
    [uploadTask resume];
    
}

@end
