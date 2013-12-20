//
//  XXUserInfoBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseTextView.h"
#import "XXUserModel.h"

@interface XXUserInfoBaseCell : UITableViewCell
{
    XXBaseTextView *contentTextView;
}

+ (NSAttributedString*)buildAttributedStringWithUserModel:(XXUserModel*)userModel;

- (void)setContentModel:(XXUserModel*)userModel;

+ (CGFloat)heightWithContentModel:(XXUserModel*)userModel;

@end
