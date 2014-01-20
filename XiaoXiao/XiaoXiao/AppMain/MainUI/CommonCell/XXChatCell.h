//
//  XXChatCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYXMPPMessage.h"
#import "XXBaseCell.h"

@interface XXChatCell : XXBaseCell
{
    XXHeadView *_headView;
    UIImageView *_bubbleBackView;
    XXBaseTextView *_contentTextView;
    
    XXRecordButton *_recordButton;
    UIImageView *_recordGif;
    UIActivityIndicatorView *_activeView;
    
    UIImageView *_contentImageView;
    UILabel     *_timeLabel;
    
}

- (void)setXMPPMessage:(ZYXMPPMessage*)aMessage;
+ (CGFloat)heightWithXMPPMessage:(ZYXMPPMessage*)aMessage  forWidth:(CGFloat)width;
- (void)setSendingState:(BOOL)state;
@end
