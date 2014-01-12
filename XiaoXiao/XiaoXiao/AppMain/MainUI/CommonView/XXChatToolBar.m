//
//  XXChatToolBar.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatToolBar.h"

@implementation XXChatToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame forUse:(XXChatToolBarType)barType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _barType = barType;
        
        _textButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _textButton.frame = CGRectMake(0,0,35,35);
        [_textButton defaultStyle];
        [_textButton setNormalIconImage:@"chat_bar_text.png" withSelectedImage:@"chat_bar_text.png" withFrame:CGRectMake(5,9,25,14)];
        [self addSubview:_textButton];
        
        _recordButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = _textButton.frame;
        [_recordButton defaultStyle];
        [_recordButton setNormalIconImage:@"chat_bar_audio.png" withSelectedImage:@"chat_bar_audio.png" withFrame:CGRectMake(5,9,25,14)];
        [self addSubview:_recordButton];
        
        //input text view
        _inputBackImageView = [[UIImageView alloc]init];
        _inputBackImageView.frame = CGRectMake(35,0,220,35);
        _inputBackImageView.backgroundColor = [UIColor whiteColor];
        _inputBackImageView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        [self addSubview:_inputBackImageView];
        
        //input text
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.frame = CGRectMake(35,0,220,35);
        [self addSubview:_inputTextView];
        
        //emoji
        _emojiButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.frame = CGRectMake(235,0,35,35);
        [_emojiButton defaultStyle];
        [_emojiButton setNormalIconImage:@"chat_bar_emoji.png" withSelectedImage:@"chat_bar_emoji.png" withFrame:CGRectMake(5,9,25,14)];
        [self addSubview:_emojiButton];
        
        //image
        _imageButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(270, 0, 35, 35);
        [_imageButton defaultStyle];
        [_imageButton setNormalIconImage:@"chat_bar_image.png" withSelectedImage:@"chat_bar_image.png" withFrame:CGRectMake(5,9,25,14)];
        [self addSubview:_imageButton];
        
        [self adjustFrameForCurrentType];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)adjustFrameForCurrentType
{
    switch (_barType) {
        case XXChatToolBarShare:
        {
            
        }
            break;
        case XXChatToolBarDefault:
        {
            
        }
            break;
        case XXChatToolBarComment:
        {
            _imageButton.hidden = YES;
            _inputBackImageView.frame = CGRectMake(_inputBackImageView.frame.origin.x,0,_inputBackImageView.frame.size.width+35,_inputBackImageView.frame.size.height);
            _inputTextView.frame = CGRectMake(_inputTextView.frame.origin.x,0,_inputTextView.frame.size.width+35,_inputTextView.frame.size.height);
            _emojiButton.frame = CGRectMake(_emojiButton.frame.origin.x+35,0,_emojiButton.frame.size.width,_emojiButton.frame.size.height);
        }
            break;
        default:
            break;
    }
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

@end
