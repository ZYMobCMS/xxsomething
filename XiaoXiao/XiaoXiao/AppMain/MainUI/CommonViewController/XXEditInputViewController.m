//
//  XXEditInputViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXEditInputViewController.h"

@interface XXEditInputViewController ()

@end

@implementation XXEditInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithFinishAction:(XXEditInputViewControllerFinishBlock)finishBlock
{
    if (self = [super init]) {
        
        _finishBlock = [finishBlock copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        if (_finishBlock) {
            _finishBlock(_inputTextView.text);
        }
    } withTitle:@"完成"];
    
    _inputTextView = [[UITextView alloc]init];
    _inputTextView.frame = CGRectMake(10,30,self.view.frame.size.width-20,50);
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeyDone;
    [_inputTextView becomeFirstResponder];
    [self.view addSubview:_inputTextView];
    
}
- (NSString*)resultText
{
    return _inputTextView.text;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
