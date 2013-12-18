//
//  XXShareBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSharePostModel.h"

typedef void (^XXShareTextViewDidTapOnThumbImageBlock) (NSURL *imageUrl);
typedef void (^XXShareTextViewDidTapOnAudioImageBlock) (NSURL *audioUrl);

//用于加入到超链接中，以实现放大图片，播放音频类型判断 ,例如 ：  xxshare_image:http://www.test.com/1.png xxshare_audio:http://www.test.com/a.audio
#define XXMIMETypeImageFormatte @"xxshare_image:"
#define XXMIMETypeAudioFormatte @"xxshare_audio:"
#define XXSharePostJSONTypeKey  @"xxshare_post_type"
#define XXSharePostJSONImageKey @"xxshare_post_images"
#define XXSharePostJSONAudioKey @"xxshare_post_audio"
#define XXSharePostJSONContentKey @"xxshare_post_content"

//分享内容规则
/*
 *
 {
 xxshare_post_type:XXSharePostType;         //定义分享内容模板，如 一个图片带一个音频，两个图片带一个音频
 xxshare_post_images:xx.png|xxx.png|xxx.png;//定义分享的图片的链接, | 隔开，区分图片
 xxshare_post_audio:xx.caf;                 //定义音频地址
 xxshare_post_content:@"test share content";//定义分享的文字内容
 }
 *
 */

@interface XXShareBaseCell : UITableViewCell<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
{
    UIImageView *backgroundImageView;
    DTAttributedTextContentView *shareTextView;
    
    XXShareTextViewDidTapOnAudioImageBlock _tapAudioBlock;
    XXShareTextViewDidTapOnThumbImageBlock _tapImageBlock;
}

- (void)setSharePostModel:(XXSharePostModel*)postModel;
+ (CGFloat)heightWithSharePostModel:(XXSharePostModel*)postModel forContentWidth:(CGFloat)contentWidth;

//限定宽度内所需最大高度
+ (CGFloat)heightForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;

- (void)setTapOnAudioImageBlock:(XXShareTextViewDidTapOnAudioImageBlock)tapAudioBlock;
- (void)setTapOnThumbImageBlock:(XXShareTextViewDidTapOnThumbImageBlock)tapImageBlock;

+ (NSAttributedString*)buildAttributedStringWithSharePost:(XXSharePostModel*)sharePost forContentWidth:(CGFloat)width;


@end
