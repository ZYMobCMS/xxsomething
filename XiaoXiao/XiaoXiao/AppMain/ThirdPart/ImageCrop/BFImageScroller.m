//
//  BFImageScroller.m
//  PPFIphone
//
//  Created by barfoo2 on 13-7-12.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "BFImageScroller.h"

@implementation BFImageScroller
@synthesize contentImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:contentImageView];
        contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [contentImageView addSubview:_indicatorView];
        _indicatorView.center = contentImageView.center;
        _indicatorView.hidden = YES;
    }
    return self;
}

- (void)startLoading
{
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

- (void)stopLoading
{
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)resetContentImageViewCenter
{
    self.contentImageView.center = CGPointMake(0,self.contentSize.height/2);
}

@end
