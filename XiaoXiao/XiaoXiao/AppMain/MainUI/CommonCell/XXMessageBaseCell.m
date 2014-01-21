//
//  XXMessageBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXMessageBaseCell.h"

@implementation XXMessageBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin,_topMargin,55,55)];
        [self.contentView addSubview:_headView];
        
        _userHeadView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(_leftMargin,_topMargin,self.contentView.frame.size.width-2*_leftMargin,100)];
        [self.contentView addSubview:_userHeadView];
        
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:CGRectMake(_leftMargin+_userHeadView.frame.size.width+_leftMargin,_userHeadView.frame.origin.y+_userHeadView.frame.size.height+_topMargin,_userHeadView.frame.size.width,10)];
        [self.contentView addSubview:_contentTextView];
        
        _recordButton = [[XXRecordButton alloc]initWithFrame:CGRectMake(_userHeadView.frame.origin.x+_userHeadView.frame.size.width+_leftMargin,_userHeadView.frame.origin.y+_userHeadView.frame.size.height+_topMargin,100,40)];
        [self.contentView addSubview:_recordButton];
        
        _recieveTimeLabel = [[UILabel alloc]init];
        _recieveTimeLabel.frame = CGRectMake(260,65,55,30);
        _recieveTimeLabel.backgroundColor = [UIColor clearColor];
        _recieveTimeLabel.textAlignment = NSTextAlignmentRight;
        _recieveTimeLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_recieveTimeLabel];
        
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCommentModel:(XXCommentModel *)aComment
{
    [_headView setHeadWithUserId:aComment.userId];
    [_contentTextView setAttributedString:aComment.contentAttributedString];
    _recieveTimeLabel.text = aComment.friendAddTime;
}
- (void)setXMPPMessage:(ZYXMPPMessage *)aMessage
{
    [_headView setHeadWithUserId:aMessage.userId];
    [_contentTextView setAttributedString:aMessage.messageAttributedContent];
    
}

@end
