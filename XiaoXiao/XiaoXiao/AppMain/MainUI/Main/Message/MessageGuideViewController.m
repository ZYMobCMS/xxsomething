//
//  MessageGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MessageGuideViewController.h"
#import "AudioMessageListViewController.h"
#import "TeaseMeListViewController.h"
#import "ReplyMessageListViewController.h"

@interface MessageGuideViewController ()

@end

@implementation MessageGuideViewController

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
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    CGFloat totalWidth = self.view.frame.size.width;

    NSMutableArray *tabBarConfig = [NSMutableArray array];
    NSDictionary *audioMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"留声机",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:audioMsgItem];
    
    NSDictionary *teaseMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"挑逗",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:teaseMsgItem];
    
    NSDictionary *replyMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"回复",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:replyMsgItem];
    
    _menuBar = [[MessageGuideTabBar alloc]initWithFrame:CGRectMake(0,0,totalWidth,40) withConfigArray:tabBarConfig];
    [self.view addSubview:_menuBar];
    
    //view controllers
    _viewControllers = [[NSMutableArray alloc]init];
    AudioMessageListViewController *audioListVC = [[AudioMessageListViewController alloc]init];
    [_viewControllers addObject:audioListVC];
    //默认
    audioListVC.view.frame = CGRectMake(0,40,totalWidth,totalHeight-40);
    [self.view addSubview:audioListVC.view];
    
    
    TeaseMeListViewController *teaseMeList = [[TeaseMeListViewController alloc]init];
    [_viewControllers addObject:teaseMeList];
    
    ReplyMessageListViewController *replyList = [[ReplyMessageListViewController alloc]init];
    [_viewControllers addObject:replyList];
    
    WeakObj(_viewControllers) weakViewControllers = _viewControllers;
    WeakObj(self) weakSelf = self;
    [_menuBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
       
        UIViewController *selectVC = [weakViewControllers objectAtIndex:index];
        if ([weakSelf.view.subviews containsObject:selectVC.view]) {
            
            [weakSelf.view bringSubviewToFront:selectVC.view];
        }else{
            
            selectVC.view.frame = CGRectMake(0,40,totalWidth,totalHeight-40);
            [weakSelf.view addSubview:selectVC.view];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
