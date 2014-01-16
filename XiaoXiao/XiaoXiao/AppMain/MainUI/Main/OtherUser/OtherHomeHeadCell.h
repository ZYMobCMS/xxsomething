//
//  OtherHomeHeadCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherUserHomeHeadView.h"

@interface OtherHomeHeadCell : UITableViewCell
{
    OtherUserHomeHeadView *_headView;
}
- (void)setContentUser:(XXUserModel*)aUser;
@end
