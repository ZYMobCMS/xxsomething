//
//  BFImageScroller.h
//  PPFIphone
//
//  Created by ZYVincent on 13-7-12.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFImageScroller : UIScrollView
{
    UIActivityIndicatorView *_indicatorView;
}
@property (nonatomic,retain)UIImageView *contentImageView;

- (void)resetContentImageViewCenter;
- (void)startLoading;
- (void)stopLoading;

@end
