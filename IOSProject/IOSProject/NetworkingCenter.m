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
static NSString *const inviteGroupPersonsURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/group/group_invite/";
//뒤에 id/ 붙여야함
static NSString *const postDiaryURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_list/";
static NSString *const diaryListURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_list/";
static NSString *const diaryInfoURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_detail/";
static NSString *const myInfoURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/member/myinfo/";
static NSString *const deleteDiaryURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_detail/";
static NSString *const likeURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_like/";
static NSString *const dislikeURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/post_dislike/";
static NSString *const deleteGroupURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/group/group_delete/";
static NSString *const createCommentURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/comment_create/";
static NSString *const deleteCommentURLString = @"http://glue2-eb-dev.ap-northeast-2.elasticbeanstalk.com/posts/comment_detail/";
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
//modify diary
static NSString *const modifiedContent = @"content";

//comment
static NSString *const createComment = @"content";
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
+ (void)creatNewGroupWithGroupTitle:(NSString *)name groupImage:(UIImage *)image  handler:(requestHandler)handler{
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:name forKey:groupName];

    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:groupURLString parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:groupImage
                                fileName:@"image.png"
                                mimeType:@"image/png"];
    } error:nil];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
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
                          NSString *groupId = [responseObject objectForKey:@"id"];
                          handler(groupId);
                        }
                  }];
    
    [uploadTask resume];
}

#pragma -mark groupList method
+ (void)showGroupList:(requestHandler)handler{
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

+ (void)deleteGroupForGroupID:(NSInteger)groupID handler:(requestHandler)handler{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"POST";
    
    NSString *deleteGroupURL = [deleteGroupURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",groupID]];
    
    [request setURL:[NSURL URLWithString:deleteGroupURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"obj:%@",responseObject);
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
            }
            
        }
    }];
    [dataTask resume];
}


#pragma -mark login method
+ (void)loginWithEmail:(NSString *)emailAddress password:(NSString *)password loginHandler:(requestHandler)loginHandler{
    
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
        
        
        [formData appendPartWithFileData:image
                                    name:imageString
                                fileName:@"image.png"
                                mimeType:@"image/png"];
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

+ (void)postDiaryWithGroupId:(NSInteger)groupId postText:(NSString *)postText selectedImages:(NSArray *)imageInfos postDiaryHander:(requestHandler)handler{
    
    NSString *groupIdString = [NSString stringWithFormat:@"%ld",groupId];
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:groupIdString forKey:groupID];
    [bodyParams setObject:postText forKey:content];
    
    NSString *groupURL = [postDiaryURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",groupId]];
   
   
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:groupURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        for ( NSInteger i=0;i<imageInfos.count;i++) {
            
            NSData *imageData = UIImageJPEGRepresentation(imageInfos[i],0.1);
            
            [formData appendPartWithFileData:imageData
                                        name:photos
                                    fileName:@"image.png"
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
                          NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
                          [DiaryModel sharedData].seletedDiaryPK = [[dic objectForKey:@"pk"] integerValue];
                          handler(succcess);
                      }
                  }];
    
    [uploadTask resume];
}

+ (void)diaryListForGroupID:(NSInteger)groupID handler:(requestHandler)handler{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    
    NSString *diaryURL = [diaryListURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",groupID]];
   
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


+ (void)diaryListForNextURL:(NSString *)nextURL handler:(requestHandler)handler{
    
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

+ (void)invitePersonsOfGroupForPhoneNumber:(NSArray *)selectedPersons groupID:(NSInteger)groupID handler:(requestHandler)handler{
    //그룹아이디 url주소에 붙이기
    NSString *groupIdString = [NSString stringWithFormat:@"%ld/",groupID];
    NSString *groupPk = [NSString stringWithFormat:@"%ld",groupID];
    NSString *urlString = [inviteGroupPersonsURLString stringByAppendingString:groupIdString];
    
    NSDictionary *bodyParams = [[NSDictionary alloc]init];
    
//    [bodyParams setObject:groupPk forKey:@"group_pk"];
//    [bodyParams setObject:selectedPersons forKey:@"phone_number"];
    
    bodyParams =@{
                  @"group_pk":groupPk,
                  @"phone_number":selectedPersons
                      };
    NSLog(@"바디파람%@",bodyParams);
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:bodyParams error:
                                    nil];
                                    
                                
    
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
      [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSLog(@"requestHeader :%@",request.allHTTPHeaderFields);

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
                          
                          NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                          NSString *strDic = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                          NSLog(@">>>>>> %s - %@", __func__, strDic);
                            handler(succcess);
                      }
                  }];
    
    [uploadTask resume];
    
}


+ (void)diaryForPostID:(NSInteger)diaryID handler:(requestHandler)handler{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    
    NSString *diaryURL = [diaryInfoURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    NSLog(@"다이어리 :%@",diaryURL);
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
                [DiaryModel sharedData].diaryInfo  = [NSMutableDictionary dictionaryWithDictionary:arr];
                NSLog(@"다이어리리스트:%@",[DiaryModel sharedData].diaryInfo);
                ;
                 [[DiaryModel sharedData] commentsOfDiaryInfo];
                NSLog(@"코멘트인포:%@",[DiaryModel sharedData].commentsInfo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
    
            }
            
        }
    }];
    [dataTask resume];
    
    
    
}

+ (void)myInfoAtApp:(requestHandler)handler{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"GET";
    
    [request setURL:[NSURL URLWithString:myInfoURLString]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"응답%@",responseObject);
                
                [MyInfoModel sharedData].myInfo = responseObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                  
                });
                
            }
            
        }
    }];
    [dataTask resume];
}

+ (void)deleteFordiaryID:(NSInteger)diaryID handler:(requestHandler)handler{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"DELETE";
    
    NSString *deleteURL = [deleteDiaryURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    NSLog(@"다이어리리스트 :%@",deleteURL);
    [request setURL:[NSURL URLWithString:deleteURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
                
                
                
            }
            
        }
    }];
    [dataTask resume];
    
    
    
}

+ (void)likeForDiaryID:(NSInteger)diaryID handler:(requestHandler)handler{

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"POST";
    
    NSString *likeURL = [likeURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    
    [request setURL:[NSURL URLWithString:likeURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"obj:%@",responseObject);
                [DiaryModel sharedData].likeInfo = responseObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
            }
            
        }
    }];
    [dataTask resume];
}
+ (void)dislikeForDiaryID:(NSInteger)diaryID handler:(requestHandler)handler{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"POST";
    
    NSString *dislikeURL = [dislikeURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    
    [request setURL:[NSURL URLWithString:dislikeURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"obj:%@",responseObject);
                
                
                [DiaryModel sharedData].likeInfo = responseObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
            }
            
        }
    }];
    [dataTask resume];
}
#pragma -mark modifyContent
+ (void)modifyContentForDiaryID:(NSInteger)diaryID content:(NSString *)content handler:(requestHandler)handler{
    NSLog(@"content%@",content);
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:content forKey:modifiedContent];

      NSString *diaryURL = [diaryInfoURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PATCH" URLString:diaryURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
  
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"%@",responseObject);
                NSString *contents = [responseObject objectForKey:modifiedContent] ;
                NSLog(@"컨텐츠 :%@",contents);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(contents);
                });
                
            }
            
        }
    }];
    [dataTask resume];
}

+ (void)createCommentsForDiaryID:(NSInteger)diaryID content:(NSString *)comment handler:(createCommentHandler)handler{
    NSLog(@"content%@",comment);
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc]init];
    [bodyParams setObject:comment forKey:createComment];
    
    NSString *diaryURL = [createCommentURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",diaryID]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:diaryURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } error:nil];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
         //   handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"%@",responseObject);
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSLog(@"obj:%@",responseObject);
                               NSLog(@"코멘트%@",[DiaryModel sharedData].commentsInfo);
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(dic);
                });
                
            }
            
        }
    }];
    [dataTask resume];
}

+ (void)deleteCommentsForCommentID:(NSInteger)commentID handler:(requestHandler)handler{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"DELETE";
    
    NSString *deleteCommentURL = [deleteCommentURLString stringByAppendingString:[NSString stringWithFormat:@"%ld/",commentID]];
    
    [request setURL:[NSURL URLWithString:deleteCommentURL]];
    [request setValue:[UtilityClass tokenForHeader] forHTTPHeaderField:authorization];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            handler(fail);
        } else {
            
            if (responseObject) {
                
                NSLog(@"success");
                NSLog(@"obj:%@",responseObject);
                
                
              //  [DiaryModel sharedData].likeInfo = responseObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    handler(succcess);
                });
            }
            
        }
    }];
    [dataTask resume];
}



@end
