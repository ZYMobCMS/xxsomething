//
//  SettingViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.title = @"Setting";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishSettingAction:(id)sender {
    
    if (self.hostTextField.text) {
        [[ZYXMPPClient shareClient]setJabbredServerAddress:self.hostTextField.text];
    }
    if (self.portTextField.text) {
        [[ZYXMPPClient shareClient]setJabbredServerPort:self.portTextField.text];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
