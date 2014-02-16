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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //back
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,self.frame.size.width-2*_leftMargin,10);
        _backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_backgroundImageView];
        
        //headView
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin*2,_topMargin,45,45)];
        [self.contentView addSubview:_headView];
        
        //name label
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_innerMargin/2,_topMargin+7,_backgroundImageView.frame.size.width-4*_leftMargin-_headView.frame.size.width,20);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        [_backgroundImageView addSubview:_nameLabel];
        
        //content text
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin,_backgroundImageView.frame.size.width-4*_leftMargin-_headView.frame.size.width,30)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_contentTextView];
        
        //audio
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioButton.frame = CGRectMake(_nameLabel.frame.origin.x+50,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin,80,35);
        [_audioButton defaultStyle];
        _audioButton.layer.cornerRadius = 15.0f;
        [_backgroundImageView addSubview:_audioButton];
        
        //
        _audioActiveView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_audioButton addSubview:_audioActiveView];
        
        //play state icon
        _playStateImageView = [[UIImageView alloc]init];
        _playStateImageView.frame = CGRectMake(30,10,12,12);
        _playStateImageView.image = [UIImage imageNamed:@"audio_play_stop.png"];
        [_audioButton addSubview:_playStateImageView];
        
        //time
        _audioTimeLabel = [[UILabel alloc]init];
        _audioTimeLabel.frame = CGRectMake(40,5,15,35);
        _audioTimeLabel.backgroundColor = [UIColor clearColor];
        _audioTimeLabel.textColor = [UIColor blackColor];
        _audioTimeLabel.font = [UIFont systemFontOfSize:9];
        [_audioButton addSubview:_audioTimeLabel];
        
        //_time label
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(0,0,80,20);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:9];
        [_backgroundImageView addSubview:_timeLabel];
        
        
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
        _audioButton.hidden = NO;
        _contentTextView.hidden = YES;
    }else{
        _audioButton.hidden = YES;
        _contentTextView.hidden = NO;
    }
    
    //name label
    _nameLabel.text = contentModel.userName;
    _timeLabel.text = contentModel.friendAddTime;
    _audioTimeLabel.text = contentModel.postAudioTime;
    DDLogVerbose(@"comemnt add time:%@",contentModel.userId);
    
    //head
    [_headView setHeadWithUserId:contentModel.userId];
    
    //
    if (isAudioType) {
        
        //time label
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-80;
        _timeLabel.frame = CGRectMake(timeOriginX,_audioButton.frame.origin.y+_audioButton.frame.size.height+_topMargin,80,20);
        
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+_audioButton.frame.size.height+_topMargin+_timeLabel.frame.size.height);
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:_contentTextView.frame.size.width];
        
        //reset
        _contentTextView.frame = CGRectMake(_contentTextView.frame.origin.x,_contentTextView.frame.origin.y,_contentTextView.frame.size.width,contentHeight);
        [_contentTextView setAttributedString:contentModel.contentAttributedString];
        
        //time label
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-80;
        _timeLabel.frame = CGRectMake(timeOriginX,_contentTextView.frame.origin.y+_contentTextView.frame.size.height+_topMargin,80,20);
        
        //_background
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+contentHeight+_topMargin+_timeLabel.frame.size.height);
    }
}

+ (CGFloat)heightForCommentModel:(XXCommentModel *)contentModel forWidth:(CGFloat)width
{
    BOOL isAudioType = [contentModel.postAudioTime isEqualToString:@"0"]? NO:YES;
    
    CGFloat leftMargin = 10;
    CGFloat innerMargin =10;
    CGFloat topMargin = 10;
    CGFloat headViewHeight=45;
    CGFloat audioButtonHeight = 35;
    CGFloat backgroundViewWidth = width- 2*leftMargin;
    CGFloat timeFontSize = 13;
    CGFloat timeHeight = 20;
    CGFloat contentWidth = width - 4*leftMargin - headViewHeight;
    
    CGFloat cellHeight = 0.f;
     //
    if (isAudioType) {
        
        cellHeight = topMargin + headViewHeight + innerMargin + audioButtonHeight + topMargin + timeHeight;
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:contentWidth];
        
        //_background
        cellHeight = topMargin + headViewHeight + innerMargin + contentHeight+topMargin+ timeHeight;
    }
    
    return cellHeight;

}
- (void)setCellType:(XXBaseCellType)cellType
{
    UIImage *backgroundImage = nil;
    switch (cellType) {
        case XXBaseCellTypeMiddel:
        {
            backgroundImage = [[UIImage imageNamed:@"share_post_detail_middle.png"]makeStretchForSharePostDetailMiddle];
        }
            break;
        case XXBaseCellTypeBottom:
        {
            backgroundImage = [[UIImage imageNamed:@"share_post_detail_bottom.png"]makeStretchForSharePostDetailBottom];
        }
            break;
        default:
            break;
    }
    _backgroundImageView.image = backgroundImage;
}

@end
