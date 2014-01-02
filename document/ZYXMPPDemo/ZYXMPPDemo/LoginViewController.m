//
//  LoginViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    UIBarButtonItem *settingBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(callSetting)];
    self.navigationItem.rightBarButtonItem = settingBar;
    self.acountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.nicknameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callSetting
{
    SettingViewController *settingVC = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)loginNowAction:(id)sender {
    
    if ([self.acountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.nicknameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码或账号不完善"];
        return;
    }
    [self.acountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
    
    [SVProgressHUD showWithStatus:@"login...."];
    [[ZYXMPPClient shareClient]setMyDefaultNickName:self.nicknameTextField.text];
    [[ZYXMPPClient shareClient]setStartClientSuccessAction:^(NSString *successMsg) {
        if (_loginBlock) {
            _loginBlock (YES,successMsg);
        }
    }];
    [[ZYXMPPClient shareClient]setStartClientFaildAction:^(NSString *faildMsg) {
        if (_loginBlock) {
            _loginBlock(NO,faildMsg);
        }
    }];
    [[ZYXMPPClient shareClient]startClientWithJID:self.acountTextField.text withPassword:self.passwordTextField.text];

    
}
- (void)setLoginResultBlock:(LoginClientResultBlock)loginBlock
{
    _loginBlock = [loginBlock copy];
}

@end
