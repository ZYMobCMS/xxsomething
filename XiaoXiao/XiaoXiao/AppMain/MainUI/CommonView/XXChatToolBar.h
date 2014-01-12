//
//  XXChatToolBar.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCustomButton.h"

typedef enum{
    
    XXChatToolBarDefault=0,
    XXChatToolBarComment,
    XXChatToolBarShare,
    
}XXChatToolBarType;

typedef enum {
    
    XXChatToolBarInputText = 0,
    XXChatToolBarInputAudio,
    
}XXChatToolBarInputModel;

typedef void (^XXChatToolBarDidChooseInputMode) (XXChatToolBarInputModel inputModel);
typedef void (^XXChatToolBarDidChooseImage) (void);
typedef void (^XXChatToolBarDidChooseEmoji) (void);

@interface XXChatToolBar : UIView<UITextViewDelegate>
{
    UIImageView*_inputBackImageView;
    UITextView *_inputTextView;
    XXCustomButton *_emojiButton;
    XXCustomButton *_recordButton;
    XXCustomButton *_textButton;
    XXCustomButton *_imageButton;
    
    XXChatToolBarType _barType;
}

- (id)initWithFrame:(CGRect)frame forUse:(XXChatToolBarType)barType;

@end
