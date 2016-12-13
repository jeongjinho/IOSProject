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

static NSString *const groupURLString  = @"https://glue-dev.muse9.net/group/group_list/";
static NSString *const signUpURLString = @"https://glue-dev.muse9.net/member/signup/";
static NSString *const loginURLString = @"https://glue-dev.muse9.net/member/login/";
//뒤에 id/ 붙여야함
static NSString *const postDiaryURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_list/";
static NSString *const diaryListURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_list/";
//SignUp
static NSString  *const emailString = @"email";
static NSString  *const nameString = @"name";
static NSString  *const passwordString = @"password";
static NSString  *const phoneNumberString = @"phone_number";
static NSString  *const imageString = @"image";

//CreateGroup
static NSString *const groupName = @"group_name";
static NSString *const groupImage = @"group_image";
//postDiary
static NSString *const groupID = @"group";
static NSString *const content = @"content";
static NSString *const photos = @"photos";
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
+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image groupImageFileName:(NSString *)fileName handler:(createNewGroupHandler)handler{
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:name forKey:groupName];

   NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:groupURLString parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:groupImage
                                fileName:fileName
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

#pragma -mark groupList method
+ (void)showGroupList:(groupListHandler)handler{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    [request setURL:[NSURL URLWithString:groupURLString]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
      AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                                   
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
         
            if (responseObject) {
                NSMutableArray *array = [responseObject objectForKey:@"Response"];
                
                NSLog(@"어레이 :%@",array);
                if (array != nil) {
                    NSLog(@"success");
                    
                    
                    [DiaryModel sharedData].groupList = array;
                    NSLog(@"그룹리스트 :%@", [DiaryModel sharedData].groupList);
                        }
                    }
            handler(succcess);
            }
        }];
   [dataTask resume];
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

+ (void)postDiaryWithGroupId:(NSInteger)groupId postText:(NSString *)postText selectedImages:(NSArray *)imageInfos postDiaryHander:(postDiaryHandler)handler{
    
    NSString *groupIdString = [NSString stringWithFormat:@"%ld",groupId];
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:groupIdString forKey:groupID];
    [bodyParams setObject:postText forKey:content];
    
    NSString *groupURL = [postDiaryURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",groupId]];
    NSLog(@"그룹 유알엘 :%@",groupURL);
   
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:groupURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        for ( NSInteger i=0;i<imageInfos.count;i++) {
            
            NSData *imageData = UIImageJPEGRepresentation([imageInfos[i] objectForKey:@"image"],0.1);
            NSString *fileName = [imageInfos[i] objectForKey:@"fileName"];
         //   NSLog(@"imageData :%@",imageData);
            NSLog(@"파일내임 :%@",fileName);
            
            [formData appendPartWithFileData:imageData
                                        name:photos
                                    fileName:fileName
                                    mimeType:@"image/png"];
        }
        
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

+ (void)diaryListForGroupID:(NSInteger)groupID handler:(diaryListHandler)handler{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    
    NSString *diaryURL = [diaryListURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",groupID]];
    NSLog(@"다이어리리스트 :%@",diaryURL);
    [request setURL:[NSURL URLWithString:diaryURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
               
                    NSLog(@"success");
                NSMutableDictionary *arr = responseObject;
                [DiaryModel sharedData].diaryList  = [NSMutableDictionary dictionaryWithDictionary:arr];
                NSLog(@"다이어리리스트:%@",[DiaryModel sharedData].diaryList);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       handler(succcess);
                   });
                  
                    
              
            }
           
        }
    }];
    [dataTask resume];



}


+ (void)diaryListForNextURL:(NSString *)nextURL handler:(nextPageHandler)handler{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    
    
    [request setURL:[NSURL URLWithString:nextURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSMutableDictionary *dic = responseObject;
                if([[dic objectForKey:@"next"] isKindOfClass:[NSNull class]]){
                    NSLog(@" next:%@",[dic objectForKey:@"next"]);
                    [[DiaryModel sharedData].diaryList removeObjectForKey:@"next"];
                    
                } else{
                   
                    [[DiaryModel sharedData].diaryList setValue:[dic objectForKey:@"next"] forKey:@"next"];
                
                
                }
                NSArray *addArray =[dic objectForKey:@"results"];
                
                NSMutableArray *list = [NSMutableArray arrayWithArray:[[DiaryModel sharedData].diaryList objectForKey:@"results"]];
                
                [list addObjectsFromArray:addArray];
                [[DiaryModel sharedData].diaryList removeObjectForKey:@"results"];
                [[DiaryModel sharedData].diaryList setValue:list forKey:@"results"];
              
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
                
                
                
            }
            
        }
    }];
    [dataTask resume];
    
    
    
}

@end
