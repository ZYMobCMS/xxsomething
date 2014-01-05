//
//  XXBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBaseCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    UIImageView *_cellLineImageView;
}
@property (nonatomic,strong)UIImage *backImage;
@property (strong,nonatomic)UILabel *titleLabel;
@property (nonatomic,assign)BOOL     needCustomLine;
@property (strong,nonatomic)UIImageView *accessoryView;

- (void)setCellType:(XXBaseCellType)cellType;

@end
