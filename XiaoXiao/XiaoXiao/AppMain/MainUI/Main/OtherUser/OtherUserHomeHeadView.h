//
//  OtherUserHomeHeadView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserHomeHeadView : UIView
{
    UIImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    UIImageView *_sexImageView;
    UILabel     *_starLabel;
    
    XXOpacityView *_wellknowView;
    
    XXCustomButton *_teaseButton;
}
- (void)setContentUser:(XXUserModel*)aUser;

- (void)addTagert:(id)target forTeaseAction:(SEL)teaseAction;

@end
