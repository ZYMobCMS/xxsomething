//
//  XXTeaseBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXTeaseBaseCell.h"

@implementation XXTeaseBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat totalHeight = 200;
        
        _teaseImageView = [[UIImageView alloc]init];
        _teaseImageView.frame = CGRectMake(100,30,100,100);
        [_backgroundImageView addSubview:_teaseImageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(_backgroundImageView.frame.size.width-10-27,10,27,27);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_share.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(tapOnDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_deleteButton];
        
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(160,110,40,20);
        [_backgroundImageView addSubview:_timeLabel];
        
        CGFloat originY = _teaseImageView.frame.origin.y+_teaseImageView.frame.size.height+_topMargin;
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = CGRectMake(_timeLabel.frame.origin.x+_timeLabel.frame.size.width,originY,16,16);
        [_backgroundImageView addSubview:_iconImageView];
        
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.frame = CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+_leftMargin,originY,50,20);
        _tagLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_tagLabel];
        
        //headView
        originY = _tagLabel.frame.origin.y+_tagLabel.frame.size.height+_topMargin;
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin,originY,50,50)];
        [_backgroundImageView addSubview:_headView];
        
        _userView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_leftMargin,originY,_backgroundImageView.frame.size.width-55-3*_leftMargin,55)];
        [_backgroundImageView addSubview:_userView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentModel:(XXTeaseModel *)aTease
{
    _teaseImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:aTease.postEmoji]];
    [_headView setHeadWithUserId:aTease.userId];
}

@end
