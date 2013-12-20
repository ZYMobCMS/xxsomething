//
//  GuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

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
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    logoImgView.frame = CGRectMake(50,50,50,50);
    [self.view addSubview:logoImgView];
    
    //
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(5,220,100,40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"single_button.png"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登陆校校" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(110,220,100,40);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"single_button.png"] forState:UIControlStateNormal];
    [registBtn setTitle:@"注册校校" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    //qq login
    UIButton *qqloginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqloginBtn.frame = CGRectMake(50,270,100,40);
    [qqloginBtn setBackgroundImage:[UIImage imageNamed:@"single_button.png"] forState:UIControlStateNormal];
    [qqloginBtn setTitle:@"QQ登陆" forState:UIControlStateNormal];
    [qqloginBtn addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqloginBtn];
    
    //weibo login
    UIButton *weibologinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weibologinBtn.frame = CGRectMake(50,270,100,40);
    [weibologinBtn setBackgroundImage:[UIImage imageNamed:@"single_button.png"] forState:UIControlStateNormal];
    [weibologinBtn setTitle:@"微薄登陆" forState:UIControlStateNormal];
    [weibologinBtn addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weibologinBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)loginAction
{
    
}
- (void)registAction
{
    
}
- (void)qqLoginAction
{
    
}
- (void)weiboLoginAction
{
    
}

@end

