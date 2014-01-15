//
//  XXChatCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XXChatCell : UITableViewCell
{
    XXHeadView *_headView;
    UIImageView *_bubbleBackView;
    XXBaseTextView *_contentTextView;
    
    XXCustomButton *_recordButton;
    UIImageView *_recordGif;
    UIActivityIndicatorView *_activeView;
    
    UIImageView *_contentImageView;
    UILabel     *_timeLabel;

}
@end
