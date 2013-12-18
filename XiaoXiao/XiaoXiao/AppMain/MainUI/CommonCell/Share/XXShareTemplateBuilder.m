//
//  XXShareTemplateBuilder.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareTemplateBuilder.h"

BOOL const XXLockShareCSSTemplateState = YES;

@implementation XXShareTemplateBuilder

+ (NSString*)buildCSSTemplateWithBundleFormatteFile:(NSString *)fileName withShareStyle:(XXShareStyle *)aStyle
{
    if (XXLockShareCSSTemplateState) {
        if (![fileName isEqualToString:XXBaseTextTemplateCSS]) {

            DDLogWarn(@"CSS Template has been locked,you can only use css file:%@",XXBaseTextTemplateCSS);
            
            NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:XXBaseTextTemplateCSS];
            
            return [XXShareTemplateBuilder buildCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];

        }
    }
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildCSSTemplateWithBundleFormatteFile:ccsFormatteString withShareStyle:aStyle];
}

+ (NSString*)buildCSSTemplateWithFormatte:(NSString *)cssFormatte withShareStyle:(XXShareStyle *)aStyle
{
    NSString *resultString = [NSString stringWithFormat:cssFormatte,aStyle.contentLineHeight,aStyle.contentFontSize,aStyle.contentTextColor,aStyle.contentTextAlign,aStyle.contentFontWeight,aStyle.contentFontFamily,aStyle.emojiSize,aStyle.emojiSize,aStyle.thumbImageSize,aStyle.thumbImageSize,aStyle.audioImageWidth,aStyle.audioImageHeight];
    
    return resultString;
}

+ (NSString*)buildSharePostContentWithCSSTemplate:(NSString *)cssTemplate withSharePostModel:(XXSharePostModel*)aSharePost
{
    NSString *htmlTemplate = [XXSharePostTypeConfig sharePostHTMLTemplateForType:aSharePost.postType];
    
    //替换CSS
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    aSharePost.postContent = [XXBaseTextView switchEmojiTextWithSourceText:aSharePost.postContent];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$content$!" withString:aSharePost.postContent];
    
    //替换音频
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$audio$!" withString:[XXSharePostStyle sharePostAudioSrcImageName]];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$audioUrl$!" withString:aSharePost.postAudio];

    //替换图片
    NSArray *images = [aSharePost.postImages componentsSeparatedByString:[XXSharePostStyle sharePostImagesSeprator]];
    for (int i=0; i<images.count; i++) {
        
        NSString *imageWillReplace = [NSString stringWithFormat:@"!$image%d$!",i];
        DDLogVerbose(@"image replace %@",imageWillReplace);
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:imageWillReplace withString:[images objectAtIndex:i]];
        
        //增加大图获取链接拼接
        NSString *imageLinkWillReplace = [NSString stringWithFormat:@"!$image%dLink$!",i];
        DDLogWarn(@"please set big image link url here!");
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:imageLinkWillReplace withString:[images objectAtIndex:i]];

    }
    
    return htmlTemplate;
}

@end
