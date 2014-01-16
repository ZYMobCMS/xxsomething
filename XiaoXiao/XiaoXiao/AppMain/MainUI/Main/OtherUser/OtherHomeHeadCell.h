//
//  OtherHomeHeadCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OtherUserHomeHeadViewTeaseBlock) (void);

@interface OtherHomeHeadCell : UITableViewCell
{
    UIImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    UIImageView *_sexImageView;
    UILabel     *_starLabel;
    
    XXOpacityView *_wellknowView;
    
    XXCustomButton *_teaseButton;
    
    OtherUserHomeHeadViewTeaseBlock _teaseBlock;
}
- (void)setContentUser:(XXUserModel*)aUser;
- (void)setTeaseBlock:(OtherUserHomeHeadViewTeaseBlock)teaseBlock;

@end
