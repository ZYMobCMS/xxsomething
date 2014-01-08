//
//  XXBaseIconLabelCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseIconLabelCell.h"

@implementation XXBaseIconLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBottomMargin:(CGFloat)bottomMargin
{
    if (self = [super init]) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = CGRectMake(8,7,30,30);
        [_backgroundImageView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.frame = CGRectMake(45,0,_backgroundImageView.frame.size.width-45*2,_backgroundImageView.frame.size.height);
        [_backgroundImageView addSubview:_titleLabel];
                
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setIconImage:(UIImage *)iconImage withTitle:(NSString *)title
{
    _iconImageView.image = iconImage;
    _titleLabel.text = title;
}

@end
