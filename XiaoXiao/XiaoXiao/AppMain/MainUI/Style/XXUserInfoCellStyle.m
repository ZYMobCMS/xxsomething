//
//  XXUserInfoCellStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserInfoCellStyle.h"

@implementation XXUserInfoCellStyle



+ (NSInteger)emojiSize
{
    return 18;
}
+ (NSInteger)sexTagWidth
{
    return 10;
}
+ (NSInteger)sexTagHeight
{
    return 10;
}
+ (CGFloat)lineHeight
{
    return 0.8f;
}
+ (CGFloat)contentWidth
{
    return 195;
}

//username
+ (CGFloat)userNameContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight]-0.2;
}
+ (NSInteger)userNameContentFontSize
{
    return 12.5;
}
+ (NSString*)userNameContentTextColor
{
    return @"#171b22";
}
+ (NSString*)userNameContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)userNameContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)userNameContentFontWeight
{
    return XXFontWeightBold;
}

//college
+ (CGFloat)collegeContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight]-0.2;
}
+ (NSInteger)collegeContentFontSize
{
    return 12.5;
}
+ (NSString*)collegeContentTextColor
{
    return @"#171b22";
}
+ (NSString*)collegeContentTextAlign
{
    return XXTextAlignRight;
}
+ (NSString*)collegeContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)collegeContentFontWeight
{
    return XXFontWeightNormal;
}

//starscore
+ (CGFloat)starscoreContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight];
}
+ (NSInteger)starscoreContentFontSize
{
    return 10;
}
+ (NSString*)starscoreContentTextColor
{
    return @"#a5a8ad";
}
+ (NSString*)starscoreContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)starscoreContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)starscoreContentFontWeight
{
    return XXFontWeightNormal;
}

//score
+ (CGFloat)scoreContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight];
}
+ (NSInteger)scoreContentFontSize
{
    return 10;
}
+ (NSString*)scoreContentTextColor
{
    return @"#fa5c47";
}
+ (NSString*)scoreContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)scoreContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)scoreContentFontWeight
{
    return XXFontWeightBold;
}

//profile
+ (CGFloat)profileContentLineHeight
{
    return 1.4f;
}
+ (NSInteger)profileContentFontSize
{
    return 12.5;
}
+ (NSString*)profileContentTextColor
{
    return @"#a5a8ad";
}
+ (NSString*)profileContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)profileContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)profileContentFontWeight
{
    return XXFontWeightNormal;
}

@end
