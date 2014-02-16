//
//  XXOpacityView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-14.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXOpacityView.h"

@implementation XXOpacityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
        [self addSubview:_backgroundView];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = _backgroundView.frame;
        [self addSubview:_contentLabel];
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = _backgroundView.frame;
        [self addSubview:_iconImageView];
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

@end
