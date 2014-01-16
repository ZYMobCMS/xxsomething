//
//  MyHomeUserHeadView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-14.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXOpacityView.h"
#import "XXHeadView.h"
#import "XXBaseTextView.h"
#import "XXUserModel.h"

@interface MyHomeUserHeadView : UIView
{
    UIImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    UILabel *_signuareView;
    
    XXOpacityView *_wellknowView;
    XXOpacityView *_settingView;
    
}
- (void)setContentUser:(XXUserModel*)aUser;

@end
