//
//  UtilityClass.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "UtilityClass.h"
#import <Photos/PHAsset.h>
#import <Photos/PHCollection.h>
#import <Photos/PHImageManager.h>
#import "WriteCollectionViewCell.h"
@implementation UtilityClass



+ (NSString *)GetUTF8String:(NSString *)str {
    NSArray *cho = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@" ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSArray *jung = [[NSArray alloc] initWithObjects:@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@" ㅙ",@"ㅚ",@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",@"ㅡ",@"ㅢ",@"ㅣ",nil];
    NSArray *jong = [[NSArray alloc] initWithObjects:@"",@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@" ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
    
    NSString *returnText = @"";
    for (int i=0;i<[str length];i++) {
        NSInteger code = [str characterAtIndex:i];
        if (code >= 44032 && code <= 55203) { // 한글영역에 대해서만 처리
            NSInteger UniCode = code - 44032; // 한글 시작영역을 제거
            NSInteger choIndex = UniCode/21/28; // 초성
            NSInteger jungIndex = UniCode%(21*28)/28; // 중성
            NSInteger jongIndex = UniCode%28; // 종성
            
            returnText = [NSString stringWithFormat:@"%@%@%@%@", returnText, [cho objectAtIndex:choIndex], [jung objectAtIndex:jungIndex], [jong objectAtIndex:jongIndex]];
        }
    }
    return returnText;
}
//헤더에 보낼 토큰값 만들기
+ (NSString *)tokenForHeader{
    KeychainItemWrapper *keyChain  = [[KeychainItemWrapper alloc]init];
    NSString *headerToken = [NSString stringWithFormat:@"Token %@",[keyChain objectForKey:(NSString *)kSecAttrAccount]];

    return headerToken;
}

+ (NSMutableArray *)loadImageInDevicePhotoLibray{
    NSMutableArray *loadImageDatas = [[NSMutableArray alloc]init];
    NSInteger cellCount  = 0;
    
        cellCount +=40;
    
    PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
    //
    //    // 카메라 롤에 있는 사진을 가져온다.
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *photoManager = [PHImageManager defaultManager];
    
    
    
    for (PHAsset *asset in assets) {
        
        [photoManager requestImageForAsset:asset targetSize:CGSizeMake(80,80) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [loadImageDatas addObject:result];
            //[loadImages addObject:result];
            
            
        }];

    }
    
    
        NSLog(@"cell count :%ld",cellCount);
        
        if(loadImageDatas.count ==cellCount){
            
            
            return nil ;
        }
    
    
    return loadImageDatas;
    
}

@end
