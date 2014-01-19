//
//  XXLoadMoreCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXLoadMoreCell.h"

@implementation XXLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(10,0,self.frame.size.width-20,46);
        _backgroundImageView.image = [[UIImage imageNamed:@"share_post_detail_bottom.png"]makeStretchForSharePostDetailBottom];
        [self.contentView addSubview:_backgroundImageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(70,7,34,34);
        [self.contentView addSubview:_indicatorView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(110,7,140,34);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
