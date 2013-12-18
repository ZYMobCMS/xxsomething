//
//  MainTabViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

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
    
    //custom tab bar
    [self initCustomTabBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化TabBar
- (void)initCustomTabBar
{
    NSMutableArray *tabBarConfigArray = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        
        NSString *iconNormal = [NSString stringWithFormat:@"home_tab_item%d_normal",i];
        NSString *iconSelected = [NSString stringWithFormat:@"home_tab_item%d_selected",i];
        NSString *title = @"";
        
        NSDictionary *itemDict = @{XXBarItemNormalIconKey:iconNormal,XXBarItemSelectIconKey:iconSelected,XXBarItemTitleKey:title};
        [tabBarConfigArray addObject:itemDict];
    }
    
    customTabBar = [[XXCustomTabBar alloc]initWithFrame:self.tabBar.frame withConfigArray:tabBarConfigArray];
    [self.view addSubview:customTabBar];
    //set select action
    __weak typeof(self) weakSelf = self;
    [customTabBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
        weakSelf.selectedIndex = index;
    }];
}

@end
