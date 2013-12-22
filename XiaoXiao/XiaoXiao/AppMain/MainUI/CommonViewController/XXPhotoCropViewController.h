//
//  XXPhotoCropViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFImageScroller.h"

/*
 *通用图片裁剪视图
 */
@interface XXPhotoCropViewController : UIViewController<UIScrollViewDelegate>
{
    BFImageScroller *contentScroller;
    CGFloat topVisiableHeight;
    CGFloat bottomVisiableHeigh;
}

@end
