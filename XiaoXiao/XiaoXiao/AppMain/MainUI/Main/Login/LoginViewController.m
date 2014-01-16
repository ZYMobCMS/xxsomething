//
//  LoginViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LoginViewController.h"

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
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    //
    CGFloat totalWidth = self.view.frame.size.width;
    CGFloat totalHeight = self.view.frame.size.height-44;
    
    _FormView = [[XXFormView alloc]initWithFrame:CGRectMake(40,30,totalWidth-40*2,115)];
    [self.view addSubview:_FormView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(40,155,totalWidth-40*2,45);
    [loginButton setTitle:@"马上登陆" forState:UIControlStateNormal];
    [loginButton blueStyle];
    [loginButton addTarget:self action:@selector(loginNowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginNowAction
{
    XXUserModel *newUser = [[XXUserModel alloc]init];
    newUser.account = _FormView.accountTextField.text;
    newUser.password = _FormView.passwordTextField.text;
    
    
    _hud.labelText = @"正在登陆";
    [_hud show:YES];
    [[XXMainDataCenter shareCenter]requestLoginWithNewUser:newUser withSuccessLogin:^(XXUserModel *detailUser) {
        [_hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        if (_resultBlock) {
            _resultBlock(YES);
        }
    } withFaildLogin:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
        if (_resultBlock) {
            _resultBlock(NO);
        }
    }];
}

- (void)setLoginResultBlock:(LoginViewControllerResultBlock)resultBlock
{
    _resultBlock = [resultBlock copy];
}

@end
