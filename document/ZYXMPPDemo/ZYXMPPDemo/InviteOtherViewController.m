//
//  InviteOtherViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "InviteOtherViewController.h"

@interface InviteOtherViewController ()

@end

@implementation InviteOtherViewController

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

- (void)viewDidUnload {
    [self setToUserAcountTextField:nil];
    [super viewDidUnload];
}
- (IBAction)sendInviteAction:(id)sender {
    
    if ([self.toUserAcountTextField.text isEqualToString:@""]) {
        return;
    }
    [[ZYXMPPClient shareClient]inviteUser:self.toUserAcountTextField.text toRoom:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
