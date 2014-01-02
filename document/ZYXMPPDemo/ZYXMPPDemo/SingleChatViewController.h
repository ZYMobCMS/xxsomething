//
//  SingleChatViewController.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleChatViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *toUserAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *myMessageTextField;
- (IBAction)sendMyMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *conversationTextView;

@end
