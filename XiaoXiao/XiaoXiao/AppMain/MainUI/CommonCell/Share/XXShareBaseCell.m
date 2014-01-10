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
        backgroundImageView = [[UIImageView alloc]init];
        backgroundImageView.frame = CGRectMake(10,0,self.frame.size.width-20,self.frame.size.height-20);
        backgroundImageView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        backgroundImageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:backgroundImageView];
        
        //head view
        CGFloat originX = _contentLeftMargin+10;
        CGFloat originY = _contentTopHeight+10;
        
        _headView = [[AGMedallionView alloc]initWithFrame:CGRectMake(originX,originY,70,70)];
        _headView.borderWidth = 1.0f;
        [backgroundImageView addSubview:_headView];
        
        //user View
        originX = _headView.frame.origin.x+_headView.frame.size.width + 10;
        _userView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(originX,originY+10,200,40)];
        [backgroundImageView addSubview:_userView];
        
        //time label
        CGFloat timrOriginX = _contentLeftMargin;
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.frame = CGRectMake(self.frame.size.width-timrOriginX*2-5-80,originY,50,20);
        [backgroundImageView addSubview:_timeLabel];
        
        //head sep line
        _headLineSep = [[UIImageView alloc]init];
        _headLineSep.frame = CGRectMake(_contentLeftMargin+10,_headView.frame.origin.y+_headView.frame.size.height+5,backgroundImageView.frame.size.width-20,1);
        _headLineSep.backgroundColor = [UIColor lightGrayColor];
        [backgroundImageView addSubview:_headLineSep];
        
        //post content
        shareTextView = [[DTAttributedTextContentView alloc]init];
        shareTextView.frame = CGRectMake(_contentLeftMargin+10,_headLineSep.frame.origin.y+1+_contentTopHeight+10,[XXSharePostStyle sharePostContentWidth],self.frame.size.height);
        shareTextView.delegate = self;
        [backgroundImageView addSubview:shareTextView];
        
        //bottom line
        _bottomLineSep = [[UIImageView alloc]init];
        _bottomLineSep.frame = CGRectMake(originX,10,backgroundImageView.frame.size.width,1);
        _bottomLineSep.backgroundColor = [UIColor lightGrayColor];
        [backgroundImageView addSubview:_bottomLineSep];
        
        //comment button
        _commentButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(_contentLeftMargin,10,(backgroundImageView.frame.size.width-40)/2,45)];
        _commentButton.customTitleLabel.text = @"评论";
        [backgroundImageView addSubview:_commentButton];
     
        //verline
        _bottomVerLineSep = [[UIImageView alloc]init];
        CGFloat bVerLineOriginx = _commentButton.frame.origin.x+_commentButton.frame.size.width+ 5;
        _bottomVerLineSep.frame = CGRectMake(bVerLineOriginx,_commentButton.frame.origin.y+5,1,_commentButton.frame.size.height);
        _bottomVerLineSep.backgroundColor = [UIColor lightGrayColor];
        [backgroundImageView addSubview:_bottomVerLineSep];
        
        //praise button
        _praiseButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(_commentButton.frame.origin.x+_commentButton.frame.size.width+10,10,(backgroundImageView.frame.size.width-40)/2,45)];
        _praiseButton.customTitleLabel.text = @"追捧";
        [backgroundImageView addSubview:_praiseButton];
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
    //set head view
    [_userView setContentModel:postModel];
    _timeLabel.text = postModel.addTime;
    
    [shareTextView setAttributedString:postModel.attributedContent];
    CGSize contentSize = [shareTextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:[XXSharePostStyle sharePostContentWidth]];
    DDLogVerbose(@"content Size:%f",contentSize.height);
    
    CGFloat backHeight = _contentTopHeight*2 + _headView.frame.size.height + _contentTopHeight + contentSize.height + 5 + _commentButton.frame.size.height + 50;
    
    backgroundImageView.frame = CGRectMake(backgroundImageView.frame.origin.x,backgroundImageView.frame.origin.y,backgroundImageView.frame.size.width,backHeight);
    
    shareTextView.frame = CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,contentSize.height);
    
    //bottom line
    _bottomLineSep.frame = CGRectMake(0,shareTextView.frame.origin.y+shareTextView.frame.size.height+5,_bottomLineSep.frame.size.width,1);
    
    _commentButton.frame = CGRectMake(_commentButton.frame.origin.x,_bottomLineSep.frame.origin.y+_bottomLineSep.frame.size.height+10,_commentButton.frame.size.width,_commentButton.frame.size.height);
    CGFloat bVerLineOriginx = _commentButton.frame.origin.x+_commentButton.frame.size.width+ 5;
    _bottomVerLineSep.frame = CGRectMake(bVerLineOriginx,_commentButton.frame.origin.y+5,1,_commentButton.frame.size.height);
    _praiseButton.frame = CGRectMake(_praiseButton.frame.origin.x,_bottomLineSep.frame.origin.y+_bottomLineSep.frame.size.height+10,_praiseButton.frame.size.width,_praiseButton.frame.size.height);
    

}

+ (CGFloat)heightWithSharePostModel:(XXSharePostModel *)postModel forContentWidth:(CGFloat)contentWidth
{
    CGFloat height = [XXShareBaseCell heightForAttributedText:postModel.attributedContent forWidth:[XXSharePostStyle sharePostContentWidth]] + 10+10+10*2 + 5 + 5 + 50 + 70 + 25;
    
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
