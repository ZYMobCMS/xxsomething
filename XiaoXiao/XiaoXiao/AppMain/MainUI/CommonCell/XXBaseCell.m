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
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
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
        self.selectedBackgroundView = normalBack;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _backgroundImageView.fillColor = [XXCommonStyle xxThemeBlueColor];
    }else{
        _backgroundImageView.fillColor = [UIColor whiteColor];
    }
}
- (void)setCellType:(XXBaseCellType)cellType withBottomMargin:(CGFloat)aMargin withCellHeight:(CGFloat)cellHeight withCornerRadius:(CGFloat)radius
{
    _cellLineImageView.hidden = YES;
    _backgroundImageView = [[TKRoundedView alloc]initWithFrame:CGRectMake(10,0,self.frame.size.width-20,cellHeight-aMargin)];
    _backgroundImageView.fillColor = [UIColor whiteColor];
    _backgroundImageView.borderColor = [UIColor colorWithRed:227/255.f green:230/255.f blue:232/255.f alpha:1];
    switch (cellType) {
        case XXBaseCellTypeTop:
        {
            TKRoundedCorner cornerOption = {TKRoundedCornerTopLeft|TKRoundedCornerTopRight};
            TKDrawnBorderSides bordSiedes = {TKDrawnBorderSidesAll};
            _backgroundImageView.roundedCorners = cornerOption;
            _backgroundImageView.drawnBordersSides = bordSiedes;
            _backgroundImageView.borderWidth = 1.0f;
            _backgroundImageView.cornerRadius = radius;
        }
            break;
        case XXBaseCellTypeMiddel:
        {
            TKRoundedCorner cornerOption = {TKRoundedCornerNone};
            TKDrawnBorderSides bordSiedes = {TKDrawnBorderSidesLeft|TKDrawnBorderSidesRight|TKDrawnBorderSidesBottom};
            _backgroundImageView.roundedCorners = cornerOption;
            _backgroundImageView.drawnBordersSides = bordSiedes;
            _backgroundImageView.borderWidth = 1.0f;
        }
            break;
        case XXBaseCellTypeBottom:
        {
            TKRoundedCorner cornerOption = {TKRoundedCornerBottomLeft|TKRoundedCornerBottomRight};
            TKDrawnBorderSides bordSiedes = {TKDrawnBorderSidesLeft|TKDrawnBorderSidesRight|TKDrawnBorderSidesBottom};
            _backgroundImageView.roundedCorners = cornerOption;
            _backgroundImageView.drawnBordersSides = bordSiedes;
            _backgroundImageView.borderWidth = 1.0f;
            _backgroundImageView.cornerRadius = radius;

        }
            break;
        case XXBaseCellTypeRoundSingle:
        {
            TKRoundedCorner cornerOption = {TKRoundedCornerAll};
            TKDrawnBorderSides bordSiedes = {TKDrawnBorderSidesAll};
            _backgroundImageView.roundedCorners = cornerOption;
            _backgroundImageView.drawnBordersSides = bordSiedes;
            _backgroundImageView.borderWidth = 1.0f;
            _backgroundImageView.cornerRadius = radius;

        }
            break;
        default:
            break;
    }
    [self.contentView insertSubview:_backgroundImageView atIndex:0];

}

@end
