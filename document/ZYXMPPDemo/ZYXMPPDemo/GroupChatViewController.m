//
//  GroupChatViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "GroupChatViewController.h"
#import "InviteOtherViewController.h"

@interface GroupChatViewController ()

@end

@implementation GroupChatViewController

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
    self.title = @"group chat";
    self.myMessageTextField.delegate = self;
    
    //
    UIBarButtonItem *create = [[UIBarButtonItem alloc]initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteOther)];
    self.navigationItem.rightBarButtonItem = create;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMyMessageAction:Nil];
    return NO;
}
- (void)inviteOther
{
    InviteOtherViewController *inviteOtherVC = [[InviteOtherViewController alloc]init];
    inviteOtherVC.title = @"invite other";
    [self.navigationController pushViewController:inviteOtherVC animated:YES];
}

- (IBAction)sendMyMessageAction:(id)sender {
    
    if ([self.myMessageTextField.text isEqualToString:@""]) {
        return;
    }
    ZYXMPPMessage *message = [[ZYXMPPMessage alloc]init];
    message.content = self.myMessageTextField.text;
    message.user = [[ZYXMPPClient shareClient]myNickName];
    message.audioTime = @"0";
    message.userId = [[ZYXMPPClient shareClient]myChatID];
    message.sendStatus = @"0";
    message.isReaded = @"1";
    message.messageType = [NSString stringWithFormat:@"%d",ZYXMPPMessageTypeText];
    [[ZYXMPPClient shareClient]sendRoomChatMessage:message toRoomJID:self.roomConifg.roomID];
    [[ZYXMPPClient shareClient]setDidRecievedGroupMessageAction:^(ZYXMPPMessage *newMessage) {
        NSString *message = [NSString stringWithFormat:@"%@      : %@ said: %@",newMessage.addTime,newMessage.user,newMessage.content];
        self.conversationTextView.text = [self.conversationTextView.text stringByAppendingFormat:@"%@\n\n",message];
    }];
}

- (void)didRecieveGroupMessage:(ZYXMPPMessage *)newMessage
{
    NSString *message = [NSString stringWithFormat:@"%@      : %@ said: %@",newMessage.addTime,newMessage.user,newMessage.content];
    self.conversationTextView.text = [self.conversationTextView.text stringByAppendingFormat:@"%@\n\n",message];
}

@end
