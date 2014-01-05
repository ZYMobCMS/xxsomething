//
//  XXBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseCell.h"

@implementation XXBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
        [self.contentView addSubview:_backgroundImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [XXCommonStyle schoolChooseCellTitleColor];
        self.titleLabel.font = [XXCommonStyle schoolChooseCellTitleFont];
        self.titleLabel.frame = CGRectMake(25,0,self.frame.size.width-50,self.frame.size.height);
        [self.contentView addSubview:self.titleLabel];
        
        _cellLineImageView = [[UIImageView alloc]init];
        _cellLineImageView.backgroundColor = rgb(233,233,233,1);
        _cellLineImageView.frame = CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1);
        [self.contentView addSubview:_cellLineImageView];
        
        self.accessoryView = [[UIImageView alloc]init];
        self.accessoryView.frame = CGRectMake(self.frame.size.width-36,12,20,20);
        self.accessoryView.image = [UIImage imageNamed:@"cell_indicator.png"];
        self.accessoryView.hidden = YES;
        [self.contentView addSubview:self.accessoryView];
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        normalBack.backgroundColor = [XXCommonStyle xxThemeBlueColor];
        self.selectedBackgroundView = normalBack;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setCellType:(XXBaseCellType)cellType
{
    NSString *cellBack = nil;
    switch (cellType) {
        case XXBaseCellTypeTop:
        {
            cellBack = @"cell_top.png";
        }
            break;
        case XXBaseCellTypeMiddel:
        {
            cellBack = @"cell_middle.png";
        }
            break;
        case XXBaseCellTypeBottom:
        {
            cellBack = @"cell_bottom.png";
        }
            break;
        case XXBaseCellTypeCornerSingle:
        {
            cellBack = @"cell_single.png";
        }
            break;
        case XXBaseCellTypeRoundSingle:
        {
            cellBack = @"cell_round_back.png";
        }
            break;
        default:
            break;
    }
    UIImage *bImage = [UIImage imageNamed:cellBack];
    _backgroundImageView.image = bImage;
    self.backImage = bImage;
}

@end
