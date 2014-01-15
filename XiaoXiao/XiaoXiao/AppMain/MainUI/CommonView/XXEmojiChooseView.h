//
//  XXEmojiChooseView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XXEmojiChooseViewDidChooseEmojiBlock) (NSString *emoji);
@interface XXEmojiChooseView : UIView
{
    XXEmojiChooseViewDidChooseEmojiBlock _chooseBlock;
}
- (void)setEmojiChooseBlock:(XXEmojiChooseViewDidChooseEmojiBlock)chooseBlock;
@end
