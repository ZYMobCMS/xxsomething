//
//  XXLoadMoreView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXLoadMoreView : UIView
{
    UIActivityIndicatorView *_indicatorView;
    UILabel                 *_titleLabel;
}
- (void)startLoading;
- (void)endLoading;
@end
