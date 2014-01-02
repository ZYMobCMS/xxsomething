//
//  GroupChatViewController.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *roomIDTextField;
@property (weak, nonatomic) IBOutlet UITextView *conversationTextView;
@property (weak, nonatomic) IBOutlet UITextField *myMessageTextField;
@property (nonatomic,strong)ZYXMPPRoomConfig *roomConifg;
- (IBAction)sendMyMessageAction:(id)sender;

- (void)didRecieveGroupMessage:(ZYXMPPMessage*)newMessage;

@end
