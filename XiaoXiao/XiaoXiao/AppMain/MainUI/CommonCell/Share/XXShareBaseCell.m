//
//  XXShareBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareBaseCell.h"

@implementation XXShareBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        shareTextView = [[DTAttributedTextContentView alloc]init];
        CGFloat margin = (self.frame.size.width-[XXSharePostStyle sharePostContentWidth])/2;
        shareTextView.frame = CGRectMake(margin,0,[XXSharePostStyle sharePostContentWidth],self.frame.size.height);
        shareTextView.delegate = self;
        [self.contentView addSubview:shareTextView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSharePostModel:(XXSharePostModel *)postModel
{
    [shareTextView setAttributedString:postModel.attributedContent];
    CGSize contentSize = [shareTextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:self.frame.size.width];
    shareTextView.frame = CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,contentSize.height);
}

+ (CGFloat)heightWithSharePostModel:(XXSharePostModel *)postModel forContentWidth:(CGFloat)contentWidth
{
    CGFloat height = [XXShareBaseCell heightForAttributedText:postModel.attributedContent forWidth:contentWidth];
    
    return height;
}


#pragma mark - custom DTImageView
- (UIView*)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        
        // if the attachment has a hyperlinkURL then this is currently ignored
		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
		imageView.delegate = self;
		
		// sets the image if there is one
		imageView.image = [(DTImageTextAttachment *)attachment image];
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		        
		// if there is a hyperlink then add a link button on top of this image
		if (attachment.hyperLinkURL)
		{
			// NOTE: this is a hack, you probably want to use your own image view and touch handling
			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
			imageView.userInteractionEnabled = YES;
			
			DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
			button.URL = attachment.hyperLinkURL;
			button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
			button.GUID = attachment.hyperLinkGUID;
			
			// use normal push action for opening URL
			[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
			
			// demonstrate combination with long press  暂时没用上长按事件
//            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//            [button addGestureRecognizer:longPress];
			
			[imageView addSubview:button];
		}
		
		return imageView;
        
    }else{
        return nil;
    }
}

#pragma mark DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
	NSURL *url = lazyImageView.url;
	CGSize imageSize = size;
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
	
	BOOL didUpdate = NO;
	
	// update all attachments that matchin this URL (possibly multiple images with same size)
	for (DTTextAttachment *oneAttachment in [shareTextView.layoutFrame textAttachmentsWithPredicate:pred])
	{
		// update attachments that have no original size, that also sets the display size
		if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
		{
			oneAttachment.originalSize = imageSize;
			
			didUpdate = YES;
		}
	}
	
	if (didUpdate)
	{
		// layout might have changed due to image sizes
		[shareTextView relayoutText];
	}
}


- (void)setAttributedText:(NSAttributedString *)attributedText
{
    //    DDLogVerbose(@"attributed Text:%@",attributedText);
    [shareTextView setAttributedString:attributedText];
        CGFloat heightForAttributedText = [XXShareBaseCell heightForAttributedText:attributedText forWidth:shareTextView.frame.size.width];
    [shareTextView setFrame:CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,heightForAttributedText)];
    
}

+ (CGFloat)heightForAttributedText:(NSAttributedString *)attributedText forWidth:(CGFloat)width
{
    //    DDLogVerbose(@"%@",attributedText);
    
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    
    return contentSize.height;
}

#pragma mark - block
- (void)linkPushed:(DTLinkButton*)linkButton
{
    //图片
    NSRange imageRange = [linkButton.URL.absoluteString rangeOfString:XXMIMETypeImageFormatte];
    if (imageRange.location!=NSNotFound) {
        
        NSString *imageUrl = [linkButton.URL.absoluteString substringWithRange:NSMakeRange(imageRange.length,linkButton.URL.absoluteString.length-imageRange.length)];
        
        NSURL *imageRealURL = [NSURL URLWithString:imageUrl];
        
        if (_tapImageBlock) {
            _tapImageBlock(imageRealURL);
        }
        
    }
    
    //音频
    NSRange audioRange = [linkButton.URL.absoluteString rangeOfString:XXMIMETypeAudioFormatte];
    if (audioRange.location!=NSNotFound) {
        
        NSString *audioUrl = [linkButton.URL.absoluteString substringWithRange:NSMakeRange(audioRange.length,linkButton.URL.absoluteString.length-audioRange.length)];
        
        NSURL *audioRealURL = [NSURL URLWithString:audioUrl];
        
        if (_tapAudioBlock) {
            _tapAudioBlock(audioRealURL);
        }
    }
    
}

- (void)setTapOnAudioImageBlock:(XXShareTextViewDidTapOnAudioImageBlock)tapAudioBlock
{
    _tapAudioBlock = [tapAudioBlock copy];
}
- (void)setTapOnThumbImageBlock:(XXShareTextViewDidTapOnThumbImageBlock)tapImageBlock
{
    _tapImageBlock = [tapImageBlock copy];
}

#pragma mark - 创建最终要显示的内容
+ (NSAttributedString*)buildAttributedStringWithSharePost:(XXSharePostModel *)sharePost forContentWidth:(CGFloat)width
{
    XXShareStyle *shareStyle = [XXShareStyle shareStyleForSharePostType:sharePost.postType withContentWidth:width];
    NSString *cssTemplate = [XXShareTemplateBuilder buildCSSTemplateWithBundleFormatteFile:XXBaseTextTemplateCSS withShareStyle:shareStyle];
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostContentWithCSSTemplate:cssTemplate withSharePostModel:sharePost];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}

@end
