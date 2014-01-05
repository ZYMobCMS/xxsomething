//
//  XXBaseIconLabelCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseCell.h"

@interface XXBaseIconLabelCell : XXBaseCell
{
    UIImageView  *_iconImageView;
    UILabel      *_titleLabel;
    CGFloat     _bottomMargin;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBottomMargin:(CGFloat)bottomMargin;
- (void)setIconImage:(UIImage *)iconImage withTitle:(NSString*)title;
- (void)setCellType:(XXBaseCellType)cellType;
@end
