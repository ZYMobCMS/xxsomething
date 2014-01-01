//
//  XXFormView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXFormView.h"

@implementation XXFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.accountTextField = [[UITextField alloc]init];
        self.accountTextField.frame = CGRectMake(0,0,frame.size.width,45);
        self.accountTextField.placeholder = @"请输入账号";
        self.accountTextField.background = [UIImage imageNamed:@"input_box.png"];
        [self addSubview:self.accountTextField];
        
        self.passwordTextField = [[UITextField alloc]init];
        self.passwordTextField.frame = CGRectMake(0,60,frame.size.width,45);
        self.passwordTextField.background = [UIImage imageNamed:@"input_box.png"];
        self.passwordTextField.placeholder = @"请输入密码";
        self.passwordTextField.secureTextEntry = YES;
        [self addSubview:self.passwordTextField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
