//
//  XXCommonUitil.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommonUitil.h"
#import "XiaoXiaoAppDelegate.h"

@implementation XXCommonUitil
+ (void)keywindowShowProgressHUDHiddenNow
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.appHUD hide:YES];
}
+ (void)keywindowShowProgressHUDWithProgressValue:(CGFloat)progressValue withTitle:(NSString *)title
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.appHUD.mode = MBProgressHUDModeAnnularDeterminate;
    appDelegate.appHUD.progress = progressValue;
    [appDelegate.appHUD showAnimated:YES whileExecutingBlock:^{
        
    }];
}
+ (void)keywindowShowProgressHUDWithTitle:(NSString *)withTitle
{
    XiaoXiaoAppDelegate *appDelegate = (XiaoXiaoAppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.appHUD.mode = MBProgressHUDModeText;
    appDelegate.appHUD.labelText = withTitle;
    [appDelegate.appHUD show:YES];
}

+ (void)setCommonNavigationTitle:(NSString *)title forViewController:(UIViewController *)aViewController
{
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(30,4,aViewController.view.frame.size.width-60,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.backgroundColor = [UIColor clearColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor blackColor];
    aViewController.navigationItem.titleView = customTitleLabel;
}
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController *)aViewController
{
    XXResponseButton *returnCustomButton = [[XXResponseButton alloc]initWithFrame:CGRectMake(0,0,26.5,26.5)];
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button.png"] forState:UIControlStateNormal];
    [returnCustomButton setResponseButtonTapped:^{
        [aViewController.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.leftBarButtonItem = returnNavItem;
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(30,4,aViewController.view.frame.size.width-60,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.backgroundColor = [UIColor clearColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor blackColor];
    aViewController.navigationItem.titleView = customTitleLabel;
}
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController *)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction
{
    XXResponseButton *returnCustomButton = [[XXResponseButton alloc]initWithFrame:CGRectMake(0,0,26.5,26.5)];
    [returnCustomButton setBackgroundImage:[UIImage imageNamed:@"nav_return_button.png"] forState:UIControlStateNormal];
    [returnCustomButton setResponseButtonTapped:^{
        if (stepAction) {
            stepAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.leftBarButtonItem = returnNavItem;
    UILabel *customTitleLabel = [[UILabel alloc]init];
    customTitleLabel.frame = CGRectMake(30,4,aViewController.view.frame.size.width-60,aViewController.navigationController.navigationBar.frame.size.height-8);
    customTitleLabel.backgroundColor = [UIColor clearColor];
    customTitleLabel.text = aViewController.title;
    customTitleLabel.textAlignment = NSTextAlignmentCenter;
    customTitleLabel.textColor = [UIColor blackColor];
    aViewController.navigationItem.titleView = customTitleLabel;
}
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController *)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction
{
    XXResponseButton *returnCustomButton = [[XXResponseButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    returnCustomButton.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    returnCustomButton.layer.borderWidth = 1.0f;
    returnCustomButton.layer.cornerRadius = 6.0f;
    [returnCustomButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [returnCustomButton setTitle:@"下一步" forState:UIControlStateNormal];
    [returnCustomButton setTitleColor:[XXCommonStyle xxThemeButtonTitleColor] forState:UIControlStateNormal];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
}
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController *)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString *)title
{
    XXResponseButton *returnCustomButton = [[XXResponseButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    returnCustomButton.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    returnCustomButton.layer.borderWidth = 1.0f;
    returnCustomButton.layer.cornerRadius = 6.0f;
    [returnCustomButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [returnCustomButton setTitle:title forState:UIControlStateNormal];
    [returnCustomButton setTitleColor:[XXCommonStyle xxThemeButtonTitleColor] forState:UIControlStateNormal];
    [returnCustomButton setResponseButtonTapped:^{
        if (nextAction) {
            nextAction();
        }
    }];
    UIBarButtonItem *returnNavItem = [[UIBarButtonItem alloc]initWithCustomView:returnCustomButton];
    aViewController.navigationItem.rightBarButtonItem = returnNavItem;
}
@end
