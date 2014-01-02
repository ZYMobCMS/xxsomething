//
//  LoginViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFormView.h"

typedef void (^LoginViewControllerResultBlock) (BOOL resultState);

@interface LoginViewController : UIViewController
{
    XXFormView *_FormView;
    LoginViewControllerResultBlock _resultBlock;
}
- (void)setLoginResultBlock:(LoginViewControllerResultBlock)resultBlock;
@end
