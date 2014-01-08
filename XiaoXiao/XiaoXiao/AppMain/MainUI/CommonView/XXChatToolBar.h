//
//  XXChatToolBar.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCustomButton.h"

@interface XXChatToolBar : UIView
{
    UIImageView*_inputBackImageView;
    UITextView *_inputTextView;
    XXCustomButton *_emojiButton;
    XXCustomButton *_recordButton;
    XXCustomButton *_textButton;
}

@end
