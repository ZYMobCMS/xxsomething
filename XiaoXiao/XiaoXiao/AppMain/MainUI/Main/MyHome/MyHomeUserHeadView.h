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
#import "XXImageView.h"

typedef void (^MyHomeUserHeadViewDidTapThemeBackBlock) (void);

@interface MyHomeUserHeadView : UIView
{
    XXImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    UILabel *_signuareView;
    
    XXOpacityView *_wellknowView;
    XXOpacityView *_settingView;
    
    MyHomeUserHeadViewDidTapThemeBackBlock _tapBackBlock;
}
- (void)setContentUser:(XXUserModel*)aUser;
- (void)setDidTapThemeBackBlock:(MyHomeUserHeadViewDidTapThemeBackBlock)tapBlock;
- (void)updateThemeBack:(NSString*)newBackUrl;

- (void)tapOnSettingAddTarget:(id)target withSelector:(SEL)selector;

@end
