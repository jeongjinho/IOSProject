//
//  UtilityClass.h
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityClass : NSObject


+ (NSString *)GetUTF8String:(NSString *)str;
+ (NSString *)tokenForHeader;
+ (NSMutableArray *)loadImageInDevicePhotoLibray;
+ (NSDictionary *)selectedImageInDevicePhotoLibray:(NSInteger)row widthSize:(CGFloat)width heightSize:(CGFloat)height;
+ (UIImage *)resizingImage:(UIImage *)image widthSize:(CGFloat)widthSize heightSize:(CGFloat)heightSize;

+ (NSString *)fomatPhoneNumberString:(NSArray*)phoneNumbers;
@end
