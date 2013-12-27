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
    DDLogVerbose(@"cssFormatte :%@",cssFormatte);
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
    NSString *ccsFormatteString = [XXFileUitil loadStringFromBundleForName:fileName];
    
    return [XXShareTemplateBuilder buildUserCellCSSTemplateWithFormatte:ccsFormatteString withShareStyle:aStyle];
}
+ (NSString*)buildUserCellCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXUserCellStyle*)aStyle
{
    
    NSString *resultCSS = [NSString stringWithFormat:cssFormatte,
                           aStyle.emojiDes.width,aStyle.emojiDes.height,aStyle.sexTagDes.width,aStyle.sexTagDes.height,
                                aStyle.userNameDes.lineHeight,aStyle.userNameDes.fontSize,aStyle.userNameDes.fontColor,aStyle.userNameDes.fontAlign,aStyle.userNameDes.fontWeight,aStyle.userNameDes.fontFamily
                                ,aStyle.collegeDes.lineHeight,aStyle.collegeDes.fontSize,aStyle.collegeDes.fontColor,aStyle.collegeDes.fontAlign,aStyle.collegeDes.fontWeight,aStyle.collegeDes.fontFamily
                                ,aStyle.starscoreDes.lineHeight,aStyle.starscoreDes.fontSize,aStyle.starscoreDes.fontColor,aStyle.starscoreDes.fontAlign,aStyle.starscoreDes.fontWeight,aStyle.starscoreDes.fontFamily
                                ,aStyle.scoreDes.lineHeight,aStyle.scoreDes.fontSize,aStyle.scoreDes.fontColor,aStyle.scoreDes.fontAlign,aStyle.scoreDes.fontWeight,aStyle.scoreDes.fontFamily
                                ,aStyle.profileDes.lineHeight,aStyle.profileDes.fontSize,aStyle.profileDes.fontColor,aStyle.profileDes.fontAlign,aStyle.profileDes.fontWeight,aStyle.profileDes.fontFamily];
    return resultCSS;
    
}
+ (NSString*)buildUserCellContentWithCSSTemplate:(NSString*)cssTemplate withUserModel:(XXUserModel*)userModel
{
    NSString *htmlTemp= [XXFileUitil loadStringFromBundleForName:XXUserCellHtmlTemplate];
    
    //替换CSS
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssTemplate];
    
    //替换content
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$sextag$!" withString:@"xiaorentou@2x.png"];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$username$!" withString:userModel.nickName];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$college$!" withString:userModel.schoolName];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$starscore$!" withString:userModel.constellation];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$score$!" withString:userModel.score];
    htmlTemp = [htmlTemp stringByReplacingOccurrencesOfString:@"!$profile$!" withString:userModel.signature];

    return htmlTemp;
    
}


@end
