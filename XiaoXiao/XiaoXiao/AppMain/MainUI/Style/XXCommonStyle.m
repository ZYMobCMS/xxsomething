//
//  XXCommonStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommonStyle.h"

@implementation XXCommonStyle

+ (CGFloat)commonPostContentLineHeight
{
    return 2.0f;
}
+ (NSInteger)commonPostContentFontSize
{
    return 14;
}
+ (NSString*)commonPostContentTextColor
{
    return @"#463a45";
}
+ (NSString*)commonPostContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)commonPostContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)commonPostContentFontWeight
{
    return XXFontWeightNormal;
}
+ (NSInteger)commonPostEmojiSize
{
    return 24;
}

@end
