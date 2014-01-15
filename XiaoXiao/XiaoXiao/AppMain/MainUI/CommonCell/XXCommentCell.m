//
//  XXCommentCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommentCell.h"

@implementation XXCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftMargin = 10.f;
        _topMargin = 10.f;
        _innerMargin = 10.f;
        
        //back
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,self.frame.size.width-2*_leftMargin,10);
        [self.contentView addSubview:_backgroundImageView];
        
        //headView
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin,_topMargin,45,45)];
        [self.contentView addSubview:_headView];
        
        //name label
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_innerMargin,_topMargin+7,280,30);
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_nameLabel];
        
        //content text
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin,_backgroundImageView.frame.size.width-3*_leftMargin-_headView.frame.size.width,30)];
        [_backgroundImageView addSubview:_contentTextView];
        
        //audio
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioButton.frame = CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin,55,44);
        [_audioButton defaultStyle];
        _audioButton.layer.cornerRadius = 15.0f;
        [_backgroundImageView addSubview:_audioButton];
        
        //
        _audioActiveView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_audioButton addSubview:_audioActiveView];
        
        //play state icon
        _playStateImageView = [[UIImageView alloc]init];
        _playStateImageView.frame = CGRectMake(10,5,25,25);
        [_audioButton addSubview:_playStateImageView];
        
        //time
        _audioTimeLabel = [[UILabel alloc]init];
        _audioTimeLabel.frame = CGRectMake(40,5,15,35);
        _audioTimeLabel.backgroundColor = [UIColor clearColor];
        [_audioButton addSubview:_audioTimeLabel];
        
        //_time label
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(0,0,30,30);
        _timeLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_timeLabel];
        
        //cell lien
        _cellLineImageView = [[UIImageView alloc]init];
        _cellLineImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,1);
        _cellLineImageView.backgroundColor = [XXCommonStyle xxThemeButtonBoardColor];
        [_backgroundImageView addSubview:_cellLineImageView];
        

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(XXCommentModel *)contentModel
{
    BOOL isAudioType = [contentModel.postAudioTime isEqualToString:@"0"]? NO:YES;
    
    if (isAudioType) {
        _audioButton.hidden = YES;
        _contentTextView.hidden = NO;
    }else{
        _audioButton.hidden = NO;
        _contentTextView.hidden = YES;
    }
    
    //name label
    _nameLabel.text = contentModel.userName;
    
    //head
    [_headView setHeadWithUserId:contentModel.userId];
    
    //
    if (isAudioType) {
        
        //time label
        CGSize timeSize = [contentModel.friendAddTime sizeWithFont:[UIFont systemFontOfSize:_timeFontSize] constrainedToSize:CGSizeMake(100,_timeLabel.frame.size.height)];
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-timeSize.width;
        _timeLabel.frame = CGRectMake(timeOriginX,_audioButton.frame.origin.y+_audioButton.frame.size.height+_topMargin,timeSize.width,timeSize.height);
        _timeLabel.text = contentModel.friendAddTime;
        
        //cell line
        _cellLineImageView.frame = CGRectMake(_cellLineImageView.frame.origin.x,_timeLabel.frame.origin.y+_timeLabel.frame.size.height+_topMargin,_cellLineImageView.frame.size.width,_cellLineImageView.frame.size.height);
        
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+_audioButton.frame.size.height+_topMargin+_timeLabel.frame.size.height+_topMargin);
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:_contentTextView.frame.size.width];
        
        //reset
        _contentTextView.frame = CGRectMake(_contentTextView.frame.origin.x,_contentTextView.frame.origin.y,_contentTextView.frame.size.width,contentHeight);
        
        //time label
        CGSize timeSize = [contentModel.friendAddTime sizeWithFont:[UIFont systemFontOfSize:_timeFontSize] constrainedToSize:CGSizeMake(100,_timeLabel.frame.size.height)];
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-timeSize.width;
        _timeLabel.frame = CGRectMake(timeOriginX,_contentTextView.frame.origin.y+_contentTextView.frame.size.height+_topMargin,timeSize.width,timeSize.height);
        _timeLabel.text = contentModel.friendAddTime;
        
        //cell line
        _cellLineImageView.frame = CGRectMake(_cellLineImageView.frame.origin.x,_timeLabel.frame.origin.y+_timeLabel.frame.size.height+_topMargin,_cellLineImageView.frame.size.width,_cellLineImageView.frame.size.height);
        
        //_background
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+contentHeight+_topMargin+_timeLabel.frame.size.height+_topMargin);
    }
}

+ (CGFloat)heightForCommentModel:(XXCommentModel *)contentModel forWidth:(CGFloat)width
{
    BOOL isAudioType = [contentModel.postAudioTime isEqualToString:@"0"]? NO:YES;
    
    CGFloat leftMargin = 10;
    CGFloat innerMargin =10;
    CGFloat topMargin = 10;
    CGFloat headViewHeight=45;
    CGFloat audioButtonHeight = 44;
    CGFloat backgroundViewWidth = width- 2*leftMargin;
    CGFloat timeFontSize = 13;
    CGFloat timeHeight = 30;
    CGFloat contentWidth = width - 3*leftMargin - headViewHeight;
    
    CGFloat cellHeight = 0.f;
     //
    if (isAudioType) {
        
        //time label
        CGSize timeSize = [contentModel.friendAddTime sizeWithFont:[UIFont systemFontOfSize:timeFontSize] constrainedToSize:CGSizeMake(100,999)];
        CGFloat timeOriginX = backgroundViewWidth-leftMargin-timeSize.width;
        CGRect timeRect = CGRectMake(timeOriginX,topMargin+headViewHeight+innerMargin+audioButtonHeight+topMargin,timeSize.width,timeSize.height);
        
        cellHeight = topMargin + headViewHeight + innerMargin + audioButtonHeight + topMargin + timeRect.size.height + topMargin;
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:contentWidth];
        
        //reset
        CGRect contentRect = CGRectMake(leftMargin+headViewHeight+leftMargin,topMargin+headViewHeight+innerMargin,contentWidth,contentHeight);
        
        //time label
        CGSize timeSize = [contentModel.friendAddTime sizeWithFont:[UIFont systemFontOfSize:timeFontSize] constrainedToSize:CGSizeMake(100,timeHeight)];
        CGFloat timeOriginX = backgroundViewWidth-leftMargin-timeSize.width;
        CGRect timeRect = CGRectMake(timeOriginX,contentRect.origin.y+contentRect.size.height+topMargin,timeSize.width,timeSize.height);
        
        //_background
        cellHeight = topMargin + headViewHeight + innerMargin + contentHeight + topMargin + timeRect.size.height + topMargin;
    }
    
    return cellHeight;

}

@end
