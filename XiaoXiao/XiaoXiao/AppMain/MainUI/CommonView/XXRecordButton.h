//
//  XXRecordButton.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXRecordButton : UIView
{
    UIButton *_recordButton;
    UIImageView *_playStateImageView;
    UILabel  *_recordTimeLabel;
}

- (void)addTarget:(id)target withTapEnventSelector:(SEL)tapSelector;

@end
