//
//  XXCommentCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXCommentCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    
    XXHeadView *_headView;
    XXBaseTextView *_contentTextView;
    UILabel *_nameLabel;
    UIButton    *_audioButton;
    UIImageView *_playStateImageView;
    UIActivityIndicatorView *_audioActiveView;
    UILabel     *_audioTimeLabel;
    UILabel     *_timeLabel;
    
    //
    CGFloat     _leftMargin;
    CGFloat     _topMargin;
    CGFloat     _innerMargin;
    CGFloat     _timeFontSize;
    
    XXShareStyle *_contentStyle;
    
    //data
    NSString    *_audioUrl;
    
}

- (void)setCellType:(XXBaseCellType)cellType;
- (void)setCommentModel:(XXCommentModel*)contentModel;
+ (CGFloat)heightForCommentModel:(XXCommentModel*)contentModel forWidth:(CGFloat)width;

@end
