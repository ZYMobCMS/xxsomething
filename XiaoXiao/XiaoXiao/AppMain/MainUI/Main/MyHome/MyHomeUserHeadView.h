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

@interface MyHomeUserHeadView : UIView
{
    UIImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    XXBaseTextView *_signuareView;
    
    XXOpacityView *_wellknowView;
    XXOpacityView *_settingView;
    
}
@end
