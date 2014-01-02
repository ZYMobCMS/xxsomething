//
//  XXLoadMoreView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXLoadMoreView.h"

@implementation XXLoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(5,5,34,34);
        [self addSubview:_indicatorView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(59,0,frame.size.width-69,frame.size.height);
        [self addSubview:_titleLabel];
        _titleLabel.text = @"加载更多...";
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)startLoading
{
    [_indicatorView startAnimating];
}
- (void)endLoading
{
    [_indicatorView stopAnimating];
}
@end
