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
    
    //init view controllers
    NSMutableArray *subVCArray = [NSMutableArray array];
    UIImage *navigationImage = nil;
    if (IS_IOS_7) {
        navigationImage = [UIImage imageNamed:@"nav_bar_ios7.png"];
    }else{
        navigationImage = [UIImage imageNamed:@"nav_bar.png"];
    }
    SquareGuideViewController *squareGuideVC = [[SquareGuideViewController alloc]init];
    [XXCommonUitil setCommonNavigationTitle:@"校广场" forViewController:self];
    UINavigationController *squareNav = [[UINavigationController alloc]initWithRootViewController:squareGuideVC];
    [squareNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
    [subVCArray addObject:squareNav];
    
    MessageGuideViewController *messageGuideVC = [[MessageGuideViewController alloc]init];
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageGuideVC];
    [messageNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
    [subVCArray addObject:messageNav];
    
    MyHomeGuideViewController *myHomeGuideVC = [[MyHomeGuideViewController alloc]init];
    UINavigationController *myHomeNav = [[UINavigationController alloc]initWithRootViewController:myHomeGuideVC];
    [myHomeNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
    [subVCArray addObject:myHomeNav];

    self.viewControllers = subVCArray;
    
}
- (void)setTabBarHidden:(BOOL)state
{
    customTabBar.hidden = state;
    // Custom code to hide TabBar
    if ( [self.view.subviews count] < 2 ) {
        return;
    }

    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
    
    if (state) {
        contentView.frame = self.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height -
                                       self.tabBar.frame.size.height);
    }
    self.tabBar.hidden = state;
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
        
        NSDictionary *itemDict = @{XXBarItemNormalIconKey:iconNormal,XXBarItemSelectIconKey:iconSelected,XXBarItemTitleKey:title,XXBarItemTitleNormalColorKey:@"",XXBarItemTitleSelectColorKey:@""};
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
