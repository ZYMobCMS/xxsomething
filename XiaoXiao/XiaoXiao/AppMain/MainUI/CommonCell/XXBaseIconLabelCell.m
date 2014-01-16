//
//  XXBaseIconLabelCell.m
//  NavigationTest
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBaseIconLabelCell.h"

@implementation XXBaseIconLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftMargin = 10.f;
        _innerMargin = 4.f;
        _rightMargin = 10.f;
        _topMargin = 5.f;
        
        //
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = CGRectMake(2*_leftMargin,_topMargin*2+3,19,17);
        [self.contentView addSubview:_iconImageView];
        
        //
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.frame= CGRectMake(2*_leftMargin+19+_innerMargin,_topMargin,80,35);
        [self.contentView addSubview:_tagLabel];
        
        //
        _detailTagLabel = [[UILabel alloc]init];
        _detailTagLabel.textAlignment = NSTextAlignmentRight;
        _detailTagLabel.font = [UIFont systemFontOfSize:11];
        _detailTagLabel.textColor = [UIColor lightGrayColor];
        _detailTagLabel.frame = CGRectMake(_indicatorView.frame.origin.x-_innerMargin-90,_topMargin,90,35);
        _detailTagLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_detailTagLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContentDict:(NSDictionary *)contentDict
{
    _iconImageView.image = [UIImage imageNamed:[contentDict objectForKey:@"icon"]];
    _tagLabel.text = [contentDict objectForKey:@"title"];
    _detailTagLabel.text = [contentDict objectForKey:@"count"];
}

@end
