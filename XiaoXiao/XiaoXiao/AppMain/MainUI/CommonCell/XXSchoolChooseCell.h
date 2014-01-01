//
//  XXSchoolChooseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSchoolModel.h"

@interface XXSchoolChooseCell : UITableViewCell
{
}
@property (strong,nonatomic)UILabel *titleLabel;
- (void)setContentModel:(XXSchoolModel*)contentModel;
- (void)setTitle:(NSString*)title;
@end
