//
//  XXShareTemplateBuilder.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareTemplateBuilder.h"

BOOL const XXLockShareCSSTemplateState = YES;
BOOL const XXLockCommonCSSTemplateState = NO;

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

#pragma mark - 通用表情文字混排
+ (NSString*)buildCommonCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle
{
    if (XXLockCommonCSSTemplateState) {
        if (![fileName isEqualToString:XXCommonTextTemplateCSS]) {
            
            DDLogWarn(@"CSS Template has been locked,you can only use css file:%@",XXCommonTextTemplateCSS);
            
            NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:XXCommonTextTemplateCSS];
            
            return [XXShareTemplateBuilder buildCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
            
        }
    }
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildCSSTemplateWithBundleFormatteFile:ccsFormatteString withShareStyle:aStyle];
}

+ (NSString*)buildCommonCSSTemplateWithFormatte:(NSString *)cssFormatte withShareStyle:(XXShareStyle *)aStyle
{
    NSString *resultString = [NSString stringWithFormat:cssFormatte,aStyle.contentLineHeight,aStyle.contentFontSize,aStyle.contentTextColor,aStyle.contentTextAlign,aStyle.contentFontWeight,aStyle.contentFontFamily,aStyle.emojiSize,aStyle.emojiSize];
    
    return resultString;
}

+ (NSString*)buildCommonTextContentWithCSSTemplate:(NSString*)cssTemplate withConentText:(NSString*)contentText
{
    NSString *htmlTemplate = [XXFileUitil loadStringFromBundleForName:XXCommonHtmlTemplate];
    
    //替换CSS
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    contentText = [XXBaseTextView switchEmojiTextWithSourceText:contentText];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$content$!" withString:contentText];
    
    return htmlTemplate;
}

+ (NSString*)buildHtmlContentWithCSSTemplate:(NSString *)cssTemplate withHtmlTemplateFile:(NSString *)htmlTemplate withConentText:(NSString *)contentText
{
    NSString *htmlTemp= [XXFileUitil loadStringFromBundleForName:htmlTemplate];

    //替换CSS
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    contentText = [XXBaseTextView switchEmojiTextWithSourceText:contentText];
    htmlTemp = [htmlTemplate stringByReplacingOccurrencesOfString:@"!$content$!" withString:contentText];
    
    return htmlTemplate;
}

//user info cell
+ (NSString*)buildUserCellCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXUserCellStyle*)aStyle
{
    
}
+ (NSString*)buildUserCellCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXUserCellStyle*)aStyle
{
    NSArray *attributesArray = aStyle.attributesArray;
    
    NSMutableString *resultString = [NSMutableString stringWithFormat:@"%@",cssFormatte];
    
    for (int i=0; i<attributesArray.count;i++) {
        
        
        
    }
    
}
+ (NSString*)buildUserCellContentWithCSSTemplate:(NSString*)cssTemplate withUserModel:(XXUserModel*)userModel
{
    
}


@end
