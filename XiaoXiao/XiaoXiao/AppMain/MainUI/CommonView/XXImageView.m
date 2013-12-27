//
//  XXImageView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXImageView.h"

@implementation XXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:_contentImageView];
        
        _overlayView = [[DAProgressOverlayView alloc]initWithFrame:_contentImageView.bounds];
        [_contentImageView addSubview:_overlayView];

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withNeedOverlay:(BOOL)needState
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:_contentImageView];
        
        _overlayView = [[DAProgressOverlayView alloc]initWithFrame:_contentImageView.bounds];
        [_contentImageView addSubview:_overlayView];
        needOverlay = needState;
    }
    return self;
}
- (void)setImageUrl:(NSString *)imageUrl
{
    __weak typeof (DAProgressOverlayView*)safeOverlay = _overlayView;
    if (needOverlay) {
        [_contentImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageContinueInBackground progress:^(NSUInteger receivedSize, long long expectedSize) {
            
            CGFloat downloadKbSize = floorf(receivedSize);
            CGFloat totoalSize = floorf(expectedSize);
            CGFloat progressValue = downloadKbSize/totoalSize;
            DDLogVerbose(@"download image :%f",progressValue);
            [safeOverlay setProgress:progressValue];
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [safeOverlay setProgress:1.0f];
            [safeOverlay displayOperationDidFinishAnimation];
            
        }];
    }else{
        [_contentImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
}
- (void)uploadImageWithProgress:(CGFloat)progress
{
    [_overlayView setProgress:progress];
}
- (void)setContentImage:(UIImage *)image
{
    _contentImageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
