//
//  OtherHomeHeadCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "OtherHomeHeadCell.h"

@implementation OtherHomeHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headView = [[OtherUserHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        [self.contentView addSubview:_headView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentUser:(XXUserModel *)aUser
{
    [_headView setContentUser:aUser];
}

@end
