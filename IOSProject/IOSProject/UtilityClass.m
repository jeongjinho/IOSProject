//
//  UtilityClass.m
//  IOSProject
//
//  Created by 진호놀이터 on 2016. 12. 5..
//  Copyright © 2016년 진호놀이터. All rights reserved.
//

#import "UtilityClass.h"

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

@end
