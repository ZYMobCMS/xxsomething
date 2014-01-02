//
//  LoginViewController.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginClientResultBlock) (BOOL resultState,NSString *msg);

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    LoginClientResultBlock _loginBlock;
}

@property (weak, nonatomic) IBOutlet UITextField *acountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
- (IBAction)loginNowAction:(id)sender;

- (void)setLoginResultBlock:(LoginClientResultBlock)loginBlock;

@end
