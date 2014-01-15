//
//  MyHomeUserHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-14.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "MyHomeUserHeadView.h"

@implementation MyHomeUserHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _themeBackgroundView = [[UIImageView alloc]init];
        _themeBackgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height * 3/4);
        _themeBackgroundView.backgroundColor = [UIColor grayColor];
        [self addSubview:_themeBackgroundView];
        
        //
        _infoBackgroundView = [[UIImageView alloc]init];
        _infoBackgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height * 1/4);
        _infoBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_infoBackgroundView];
        
        //
        _headView = [[XXHeadView alloc]init];
        _headView.contentImageView.borderColor = [UIColor whiteColor];
        _headView.contentImageView.borderWidth = 2.0f;
        _headView.frame = CGRectMake(0,_themeBackgroundView.frame.size.height*3/4,80,80);
        
        [self addSubview:_headView];
        
        //
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(100,30,150,35);
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_infoBackgroundView addSubview:_nameLabel];
        
        //
        _signuareView = [[XXBaseTextView alloc]initWithFrame:CGRectMake(100,65,150,40)];
        [self addSubview:_signuareView];
        
        //
        _wellknowView = [[XXOpacityView alloc]initWithFrame:CGRectMake(0,30,50,25)];
        [self addSubview:_wellknowView];
        
        //settingView
        _settingView = [[XXOpacityView alloc]initWithFrame:CGRectMake(270,145,35,35)];
        [self addSubview:_settingView];
        
        
        
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
