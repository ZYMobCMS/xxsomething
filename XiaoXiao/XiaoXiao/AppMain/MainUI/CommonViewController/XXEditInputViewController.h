//
//  XXEditInputViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *基础编辑输入视图
 */
typedef void (^XXEditInputViewControllerFinishBlock) (NSString *resultText);

@interface XXEditInputViewController : UIViewController<UITextViewDelegate>
{
    UITextView  *_inputTextView;
    UIImageView *_backgroundImageView;
    XXEditInputViewControllerFinishBlock _finishBlock;
}
- (id)initWithFinishAction:(XXEditInputViewControllerFinishBlock)finishBlock;
- (NSString*)resultText;

@end
