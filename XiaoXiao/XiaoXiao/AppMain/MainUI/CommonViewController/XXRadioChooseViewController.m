//
//  XXRadioChooseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXRadioChooseViewController.h"

@interface XXRadioChooseViewController ()

@end

@implementation XXRadioChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithConfigArray:(NSArray *)configArray withRadioChooseType:(XXRadioChooseType)chooseType withFinishBlock:(XXRadioChooseViewControllerFinishBlock)finishBlock
{
    if (self = [super init]) {
        
        _finishBlock = [finishBlock copy];
        _titleArray = [[NSMutableArray alloc]initWithArray:configArray];
        _chooseType = chooseType;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        NSDictionary *selectItem = [_titleArray objectAtIndex:_chooseView.selectIndex];
        NSString *resultText = [selectItem objectForKey:@"value"];
        if (_finishBlock) {
            _finishBlock(resultText);
        }
    } withTitle:@"完成"];
    
    _chooseView = [[XXRadioChooseView alloc]initWithFrame:CGRectMake(20,50,280,300) withConfigArray:_titleArray withChooseType:_chooseType];
    [self.view addSubview:_chooseView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)finialChooseString
{
    NSDictionary *selectItem = [_titleArray objectAtIndex:_chooseView.selectIndex];
    return [selectItem objectForKey:@"value"];
}

@end
