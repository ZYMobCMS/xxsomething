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
    return 24;
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
    return 1.6f;
}

//username
+ (CGFloat)userNameContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight];
}
+ (NSInteger)userNameContentFontSize
{
    return 11;
}
+ (NSString*)userNameContentTextColor
{
    return @"#463a45";
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
    return XXFontWeightNormal;
}

//college
+ (CGFloat)collegeContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight];
}
+ (NSInteger)collegeContentFontSize
{
    return 11;
}
+ (NSString*)collegeContentTextColor
{
    return @"#463a45";
}
+ (NSString*)collegeContentTextAlign
{
    return XXTextAlignLeft;
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
    return 11;
}
+ (NSString*)starscoreContentTextColor
{
    return @"#463a45";
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
    return 11;
}
+ (NSString*)scoreContentTextColor
{
    return @"#463a45";
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
    return XXFontWeightNormal;
}

//profile
+ (CGFloat)profileContentLineHeight
{
    return [XXUserInfoCellStyle lineHeight];
}
+ (NSInteger)profileContentFontSize
{
    return 11;
}
+ (NSString*)profileContentTextColor
{
    return @"#463a45";
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
