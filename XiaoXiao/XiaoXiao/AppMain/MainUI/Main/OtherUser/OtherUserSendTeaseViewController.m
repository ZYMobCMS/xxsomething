//
//  OtherUserSendTeaseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserSendTeaseViewController.h"

@interface OtherUserSendTeaseViewController ()

@end

@implementation OtherUserSendTeaseViewController

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
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    _teaseImageView = [[UIImageView alloc]init];
    _teaseImageView.frame = CGRectMake(100,70,100,100);
    [self.view addSubview:_teaseImageView];
    
    //
    _teaseButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _teaseButton.frame = CGRectMake(110,_teaseImageView.frame.origin.y+_teaseImageView.frame.size.height+30,130, 35);
    [_teaseButton teaseStyle];
    [_teaseButton setNormalIconImage:@"other_tease.png" withSelectedImage:@"other_tease.png" withFrame:CGRectMake(20,5,27,18)];
    [_teaseButton setTitle:@"挑逗" withFrame:CGRectMake(55,5,100,30)];
    [_teaseButton addTarget:self action:@selector(sendTeaseAction) forControlEvents:UIControlEventTouchUpInside];
    _teaseButton.layer.cornerRadius = 17.f;
    [self.view addSubview:_teaseButton];
    _teaseImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:_teaseEmoji]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelecteTeaseEmoji:(NSString *)teaseName toUser:(NSString *)useId
{
    _teaseEmoji = teaseName;
    _toUserId = useId;
}
- (void)sendTeaseAction
{
    _hud.labelText = @"正在发送...";
    XXTeaseModel *newTease = [[XXTeaseModel alloc]init];
    newTease.postEmoji = _teaseEmoji;
    newTease.userId = _toUserId;
    
    [_hud show:YES];
    [[XXMainDataCenter shareCenter]requestTeaseUserWithCondtionTease:newTease withSuccess:^(NSString *successMsg) {
        [_hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:successMsg];
        NSArray *navControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[navControllers objectAtIndex:navControllers.count-3] animated:YES];
    } withFaild:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
    
}

@end
