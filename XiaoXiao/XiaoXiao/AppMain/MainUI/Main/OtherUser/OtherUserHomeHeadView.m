//
//  OtherUserHomeHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "OtherUserHomeHeadView.h"

@implementation OtherUserHomeHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _themeBackgroundView = [[UIImageView alloc]init];
        _themeBackgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height * 1/2);
        _themeBackgroundView.backgroundColor = [UIColor blueColor];
        [self addSubview:_themeBackgroundView];
        
        //
        _infoBackgroundView = [[UIImageView alloc]init];
        _infoBackgroundView.frame = CGRectMake(0,frame.size.height*1/2,frame.size.width,frame.size.height * 1/2);
        _infoBackgroundView.userInteractionEnabled = YES;
        _infoBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_infoBackgroundView];
        
        //
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(110,_themeBackgroundView.frame.size.height*1/2,100,100)];
        _headView.contentImageView.borderColor = [UIColor whiteColor];
        _headView.contentImageView.borderWidth = 2.0f;
        [self addSubview:_headView];
        
        //
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(50,30,180,35);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_infoBackgroundView addSubview:_nameLabel];
        
        //
        _wellknowView = [[XXOpacityView alloc]initWithFrame:CGRectMake(0,30,50,25)];
        [self addSubview:_wellknowView];
        
        
        //sex tag
        _sexImageView = [[UIImageView alloc]init];
        _sexImageView.frame = CGRectMake(135,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+3,10,10);
        [_infoBackgroundView addSubview:_sexImageView];
        
        //star label
        _starLabel = [[UILabel alloc]init];
        _starLabel.frame = CGRectMake(_sexImageView.frame.origin.x+_sexImageView.frame.size.width+3,_sexImageView.frame.origin.y,45,20);
        [_infoBackgroundView addSubview:_starLabel];
        
        //tease button
        _teaseButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _teaseButton.frame = CGRectMake(110,_starLabel.frame.origin.y+_starLabel.frame.size.height,130, 35);
        [_teaseButton teaseStyle];
        [_teaseButton setNormalIconImage:@"other_tease.png" withSelectedImage:@"other_tease.png" withFrame:CGRectMake(20,5,27,18)];
        [_teaseButton setTitle:@"挑逗" withFrame:CGRectMake(55,5,100,30)];
        _teaseButton.layer.cornerRadius = 17.f;
        [_infoBackgroundView addSubview:_teaseButton];
        
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
    _starLabel.text = aUser.signature;
    NSString *sexTag = [aUser.sex boolValue]? @"sex_tag_1.png":@"sex_tag_0.png";
    _sexImageView.image = [UIImage imageNamed:sexTag];
}

- (void)addTagert:(id)target forTeaseAction:(SEL)teaseAction
{
    [_teaseButton addTarget:target action:teaseAction forControlEvents:UIControlEventTouchUpInside];
}
@end
