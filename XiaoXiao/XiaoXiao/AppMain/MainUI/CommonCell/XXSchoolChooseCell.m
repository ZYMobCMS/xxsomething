//
//  XXSchoolChooseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSchoolChooseCell.h"

@implementation XXSchoolChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [XXCommonStyle schoolChooseCellTitleColor];
        self.titleLabel.font = [XXCommonStyle schoolChooseCellTitleFont];
        self.titleLabel.frame = CGRectMake(25,0,self.frame.size.width-50,self.frame.size.height);
        [self.contentView addSubview:self.titleLabel];
        
        UIView *selectBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        selectBack.backgroundColor = [XXCommonStyle xxThemeBlueColor];
        self.selectedBackgroundView = selectBack;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContentModel:(XXSchoolModel *)contentModel
{
    self.titleLabel.text = contentModel.schoolName;
}
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
@end
