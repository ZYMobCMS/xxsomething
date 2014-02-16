//
//  XXSharePostStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSharePostStyle.h"

@implementation XXSharePostStyle

+ (CGFloat)sharePostContentLineHeight;
{
    return 1.5;
}
+ (NSInteger)sharePostContentFontSize
{
    return 15;
}
+ (NSString*)sharePostContentTextColor
{
    return @"#463a45";
}
+ (NSString*)sharePostContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)sharePostContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)sharePostContentFontWeight
{
    return XXFontWeightNormal;
}
+ (NSInteger)sharePostEmojiSize
{
    return 12;
}
+ (NSInteger)sharePostAudioImageWidth
{
    return 120;
}
+ (NSInteger)sharePostAudioImageHeight
{
    return 35;
}
+ (NSInteger)sharePostSingleThumbLeftMargin
{
    return 70;
}
+ (NSInteger)sharePostTwoThumbLeftMargin
{
    return 30;
}
+ (NSString*)sharePostAudioSrcImageName
{
    return @"share_record_btton@2x.png";
}
+ (NSString*)sharePostImagesSeprator
{
    return @"|";
}
+ (CGFloat)sharePostContentWidth
{
    return 280;
}


@end
