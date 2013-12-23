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
@end
