//
//  SingleChatViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SingleChatViewController.h"

@interface SingleChatViewController ()

@end

@implementation SingleChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"sing Chat";
    self.myMessageTextField.delegate = self;
    self.myMessageTextField.returnKeyType = UIReturnKeySend;
    self.conversationTextView.font = [UIFont systemFontOfSize:11];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMyMessage:(id)sender {
    
    if (!self.toUserAccountTextField.text) {
        [SVProgressHUD showErrorWithStatus:@"to user account can not be nil!"];
        return;
    }
    if (!self.myMessageTextField.text) {
        [SVProgressHUD showErrorWithStatus:@"can't send null content"];
        return;
    }
    
     ZYXMPPUser *newUser = [[ZYXMPPUser alloc]init];
     newUser.jID = self.toUserAccountTextField.text;
     ZYXMPPMessage *message = [[ZYXMPPMessage alloc]init];
     message.content = self.myMessageTextField.text;
     message.user = [[ZYXMPPClient shareClient]myNickName];
     message.audioTime = @"0";
     message.userId = [[ZYXMPPClient shareClient]myChatID];
     message.sendStatus = @"0";
     message.isReaded = @"1";
     message.conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:newUser.jID withMyUserId:message.userId];
     message.messageType = [NSString stringWithFormat:@"%d",ZYXMPPMessageTypeText];
     [[ZYXMPPClient shareClient]  sendMessageToUser:newUser withContent:message withSendResult:^(NSString *messageId, NSString *addTime) {
     message.messageId = messageId;
     message.addTime = addTime;
         NSString *newMessage = [NSString stringWithFormat:@"%@   :%@",message.addTime,message.content];
         self.conversationTextView.text = [self.conversationTextView.text stringByAppendingFormat:@"                                         %@\n\n",newMessage];
     }];
    [[ZYXMPPClient shareClient]setDidRecievedMessage:^(ZYXMPPMessage *newMessage) {
        NSString *message = [NSString stringWithFormat:@"%@      : %@ said: %@",newMessage.addTime,newMessage.user,newMessage.content];
        self.conversationTextView.text = [self.conversationTextView.text stringByAppendingFormat:@"%@\n\n",message];
    }];
    
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMyMessage:nil];
    return NO;
}

@end
