//
//  ZYXMPPDemoAppDelegate.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "ChatChooseViewController.h"

@interface ZYXMPPDemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNav;
@property (strong ,nonatomic) ChatChooseViewController *chatChooseViewController;

@end
