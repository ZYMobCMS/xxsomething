//
//  CreateRoomViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "CreateRoomViewController.h"

@interface CreateRoomViewController ()

@end

@implementation CreateRoomViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createAction:(id)sender {
    
    if ([self.nameTextField.text isEqualToString:@""]||[self.subjectTextField.text isEqualToString:@""]) {
        return;
    }
    
    ZYXMPPRoomConfig *newConfig = [[ZYXMPPRoomConfig alloc]init];
    newConfig.name = self.nameTextField.text;
    newConfig.description = self.subjectTextField.text;
    newConfig.subject = self.subjectTextField.text;
    newConfig.needPasswordProtect = NO;
    newConfig.secret = @"";
    newConfig.maxUserCount = [self.maxUserTextField.text intValue];
    newConfig.maxHistoryMessageReturnCount = 100;
    newConfig.owner = [[ZYXMPPClient shareClient]myChatJID];
    newConfig.admins = [NSArray array];
    newConfig.enableLogging = YES;
    newConfig.allowInivite = YES;
    newConfig.allowPrivateMsg = NO;
    newConfig.whoCanDiscoveryOthersJID = ZYXMPPRoomRoleMember;
    newConfig.whoCanBroadCastMsg = ZYXMPPRoomRoleMember;
    newConfig.whoCanGetRoomMemberList = ZYXMPPRoomRoleMember;
    newConfig.needPersistThisRoom = YES;
    newConfig.isThisPublicRoom = YES;
    newConfig.isRoomForAdminOnly = NO;
    newConfig.isRoomForMemberOnly = NO;
    newConfig.reconfigState = YES;
    newConfig.roomID = [[ZYXMPPClient shareClient]genrateRoomID];
    newConfig.myNickName = [[ZYXMPPClient shareClient]myNickName];    
    if (_finishBlock) {
        _finishBlock(newConfig);
    }
}
- (void)setFinishBlock:(CreateRoomFinishBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
}
@end
