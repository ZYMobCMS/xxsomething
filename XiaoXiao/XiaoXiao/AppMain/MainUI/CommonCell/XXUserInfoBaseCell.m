//
//  XXUserInfoBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserInfoBaseCell.h"

@implementation XXUserInfoBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        contentTextView = [[XXBaseTextView alloc]init];
        contentTextView.frame = CGRectMake(50,30,220,100);
        [self.contentView addSubview:contentTextView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSAttributedString*)buildAttributedStringWithUserModel:(XXUserModel *)userModel
{
    
}

- (void)setContentModel:(XXUserModel *)userModel
{
    
}

+ (CGFloat)heightWithContentModel:(XXUserModel *)userModel
{
}

@end
