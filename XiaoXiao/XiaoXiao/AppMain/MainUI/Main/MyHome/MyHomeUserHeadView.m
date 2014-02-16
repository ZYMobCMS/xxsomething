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
        
        _themeBackgroundView = [[XXImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height * 3/4)];
        _themeBackgroundView.userInteractionEnabled = YES;
        [self addSubview:_themeBackgroundView];
        UITapGestureRecognizer *themeTapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnThemeBack:)];
        [_themeBackgroundView addGestureRecognizer:themeTapR];
        
        //
        _infoBackgroundView = [[UIImageView alloc]init];
        _infoBackgroundView.frame = CGRectMake(0,frame.size.height*3/4,frame.size.width,frame.size.height * 1/4);
        _infoBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_infoBackgroundView];
        
        //
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(15,_themeBackgroundView.frame.size.height*3/4,100,100)];
        _headView.contentImageView.borderColor = [UIColor whiteColor];
        _headView.contentImageView.borderWidth = 2.0f;        
        [self addSubview:_headView];
        
        //
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(135,0,180,35);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        [_infoBackgroundView addSubview:_nameLabel];
        
        //
        _signuareView = [[UILabel alloc]initWithFrame:CGRectMake(135,frame.size.height*3/4+25,180,35)];
        _signuareView.backgroundColor = [UIColor clearColor];
        [self addSubview:_signuareView];
        
        //
        _wellknowView = [[XXOpacityView alloc]initWithFrame:CGRectMake(0,30,50,25)];
        _wellknowView.contentLabel.textColor = [UIColor whiteColor];
        _wellknowView.contentLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_wellknowView];
        
        //settingView
        _settingView = [[XXOpacityView alloc]initWithFrame:CGRectMake(270,145,35,35)];
        _settingView.iconImageView.frame = CGRectMake(8,8,19,19);
        _settingView.iconImageView.image = [UIImage imageNamed:@"setting.png"];
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
- (void)setContentUser:(XXUserModel *)aUser
{
    [_headView setHeadWithUserId:aUser.userId];
    _nameLabel.text = aUser.nickName;
    _signuareView.text = aUser.signature;
    NSString *combineString = [NSString stringWithFormat:@"知名度:%@",aUser.wellknow];
    _wellknowView.contentLabel.text = combineString;
    
    DDLogVerbose(@"aUser for content:%@",aUser.bgImage);
    [_themeBackgroundView setImageUrl:aUser.bgImage];
}
- (void)setDidTapThemeBackBlock:(MyHomeUserHeadViewDidTapThemeBackBlock)tapBlock
{
    _tapBackBlock = [tapBlock copy];
}

- (void)didTapOnThemeBack:(UITapGestureRecognizer*)tapR
{
    if (_tapBackBlock) {
        _tapBackBlock();
    }
}

- (void)updateThemeBack:(NSString *)newBackUrl
{
    [_themeBackgroundView setImageUrl:newBackUrl];
}
- (void)tapOnSettingAddTarget:(id)target withSelector:(SEL)selector
{
    [_settingView addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
