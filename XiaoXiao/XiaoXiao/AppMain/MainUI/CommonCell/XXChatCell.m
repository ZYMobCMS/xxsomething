//
//  XXChatCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatCell.h"

@implementation XXChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect initRect = CGRectMake(0,0,1,1);
        
        _headView = [[XXHeadView alloc]initWithFrame:initRect];
        [self.contentView addSubview:_headView];
        
        _bubbleBackView = [[UIImageView alloc]init];
        _bubbleBackView.frame = initRect;
        _bubbleBackView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bubbleBackView];
        
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:initRect];
        [_bubbleBackView addSubview:_contentTextView];
        
        //record button
        _recordButton = [[XXRecordButton alloc]initWithFrame:initRect];
        [self.contentView addSubview:_recordButton];
        
        //record play gif
        _recordGif = [[UIImageView alloc]init];
        _recordGif.frame = initRect;
        [_bubbleBackView addSubview:_recordGif];
        
        //
        _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activeView.frame = initRect;
        [self.contentView addSubview:_activeView];
        
        //
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.frame = initRect;
        [_bubbleBackView addSubview:_contentImageView];
        
        //
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = initRect;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXMPPMessage:(ZYXMPPMessage *)aMessage
{
    _leftMargin = 10.f;
    _topMargin = 10.f;
    CGFloat headWidth = 25.f;
    
    CGFloat originX = 0.f;
    CGFloat originY = 0.f;
    
    CGFloat totalWidth = self.frame.size.width;
    CGFloat maxContentWidth = totalWidth-2*_leftMargin-2*headWidth-2*_leftMargin;

    //contentHeight
    CGFloat contentHeight = 0.f;
    CGFloat contentWidth = 0.f;
    
    
    
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            CGSize contentSize = [XXBaseTextView sizeForAttributedText:aMessage.messageAttributedContent forWidth:maxContentWidth];
            contentHeight = contentSize.height>headWidth? contentSize.height:headWidth;
            contentWidth = contentSize.width;
            [_contentTextView setAttributedString:aMessage.messageAttributedContent];
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            contentWidth = maxContentWidth/2;
            contentHeight = contentWidth*3/4;
            [_contentImageView setImageWithURL:[NSURL URLWithString:aMessage.content]];
        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            contentWidth = maxContentWidth/2;
            contentHeight = headWidth;
        }
            break;
        default:
            break;
    }

    if (aMessage.isFromSelf) {
        
        originX = totalWidth-_leftMargin;
        _headView.frame = CGRectMake(originX-headWidth,originY,headWidth,headWidth);
        
    }else{
        originY = _leftMargin;
        _headView.frame = CGRectMake(originX,originY,headWidth,headWidth);
    }
    _bubbleBackView.frame = CGRectMake(originX,originY,contentWidth+2*_leftMargin,contentHeight+2*_topMargin);
    if (aMessage.isFromSelf) {
        _activeView.frame = CGRectMake(_bubbleBackView.frame.origin.x-10-5,5,10,10);
    }else{
        _activeView.frame = CGRectMake(_bubbleBackView.frame.origin.x+_bubbleBackView.frame.size.width+5,5,10,10);
    }
    
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            _contentTextView.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            _contentImageView.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            _recordButton.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
        }
            break;
        default:
            break;
    }
    if(aMessage.isFromSelf){
        
    }else{
        
    }
        
    
}
+ (CGFloat)heightWithXMPPMessage:(ZYXMPPMessage *)aMessage forWidth:(CGFloat)width
{
    CGFloat totalHeight = 0.f;
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 10.f;
    CGFloat headWidth = 25.f;
    
    CGFloat totalWidth = width;
    CGFloat maxContentWidth = totalWidth-2*leftMargin-2*headWidth-2*leftMargin;
    
    //contentHeight
    CGFloat contentHeight = 0.f;
    CGFloat contentWidth = 0.f;
    
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            CGSize contentSize = [XXBaseTextView sizeForAttributedText:aMessage.messageAttributedContent forWidth:maxContentWidth];
            
            contentHeight = contentSize.height>headWidth? contentSize.height:headWidth;
            contentWidth = contentSize.width;
            
            totalHeight = 2*topMargin+contentHeight;
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            contentWidth = maxContentWidth/2;
            contentHeight = contentWidth*3/4;
            
            totalHeight = 2*topMargin+contentHeight;

        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            contentWidth = maxContentWidth/2;
            contentHeight = headWidth;
            
            totalHeight = 2*topMargin+contentHeight;

        }
            break;
        default:
            break;
    }
    
    totalHeight = totalHeight+topMargin/2;
    
    return totalHeight;
}
- (void)setSendingState:(BOOL)state
{
    if (state) {
        [_activeView startAnimating];
    }else{
        [_activeView stopAnimating];
    }
}

@end
