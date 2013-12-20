//
//  XXUserCellStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserCellStyle.h"
#import "XXUserInfoCellStyle.h"

#define XXFloatNumber(x) [NSNumber numberWithFloat:x]
#define XXIntNumber(x)   [NSNumber numberWithInt:x]

@implementation XXUserCellStyle


+ (XXUserCellStyle*)userCellStyle
{
    XXUserCellStyle *userStyle = [[XXUserCellStyle alloc]init];

    NSMutableArray *attributesArray = [NSMutableArray array];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle emojiSize])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle emojiSize])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle sexTagWidth])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle sexTagHeight])];
    
    //username
    [attributesArray addObject:XXFloatNumber([XXUserInfoCellStyle userNameContentLineHeight])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle userNameContentFontSize])];
    [attributesArray addObject:[XXUserInfoCellStyle userNameContentTextColor]];
    [attributesArray addObject:[XXUserInfoCellStyle userNameContentTextAlign]];
    [attributesArray addObject:[XXUserInfoCellStyle userNameContentFontWeight]];
    [attributesArray addObject:[XXUserInfoCellStyle userNameContentFontFamily]];
    
    
    //college
    [attributesArray addObject:XXFloatNumber([XXUserInfoCellStyle collegeContentLineHeight])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle collegeContentFontSize])];
    [attributesArray addObject:[XXUserInfoCellStyle collegeContentTextColor]];
    [attributesArray addObject:[XXUserInfoCellStyle collegeContentTextAlign]];
    [attributesArray addObject:[XXUserInfoCellStyle collegeContentFontWeight]];
    [attributesArray addObject:[XXUserInfoCellStyle collegeContentFontFamily]];
    
    //starscore
    [attributesArray addObject:XXFloatNumber([XXUserInfoCellStyle starscoreContentLineHeight])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle starscoreContentFontSize])];
    [attributesArray addObject:[XXUserInfoCellStyle starscoreContentTextColor]];
    [attributesArray addObject:[XXUserInfoCellStyle starscoreContentTextAlign]];
    [attributesArray addObject:[XXUserInfoCellStyle starscoreContentFontWeight]];
    [attributesArray addObject:[XXUserInfoCellStyle starscoreContentFontFamily]];
    
    //score
    [attributesArray addObject:XXFloatNumber([XXUserInfoCellStyle scoreContentLineHeight])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle scoreContentFontSize])];
    [attributesArray addObject:[XXUserInfoCellStyle scoreContentTextColor]];
    [attributesArray addObject:[XXUserInfoCellStyle scoreContentTextAlign]];
    [attributesArray addObject:[XXUserInfoCellStyle scoreContentFontWeight]];
    [attributesArray addObject:[XXUserInfoCellStyle scoreContentFontFamily]];
    
    //profile
    [attributesArray addObject:XXFloatNumber([XXUserInfoCellStyle profileContentLineHeight])];
    [attributesArray addObject:XXIntNumber([XXUserInfoCellStyle profileContentFontSize])];
    [attributesArray addObject:[XXUserInfoCellStyle profileContentTextColor]];
    [attributesArray addObject:[XXUserInfoCellStyle profileContentTextAlign]];
    [attributesArray addObject:[XXUserInfoCellStyle profileContentFontWeight]];
    [attributesArray addObject:[XXUserInfoCellStyle profileContentFontFamily]];
    
    userStyle.attributesArray = attributesArray;
    
    return userStyle;
    
}

@end
