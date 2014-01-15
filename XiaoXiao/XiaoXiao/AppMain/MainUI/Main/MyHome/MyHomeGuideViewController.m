//
//  MyHomeGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyHomeGuideViewController.h"

@interface MyHomeGuideViewController ()

@end

@implementation MyHomeGuideViewController

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

    //
    guideVCArray = [[NSMutableArray alloc]init];
    
    //my share
    NSDictionary *myShare = @{@"title":@"相册",@"vcClass":@"MyShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    NSDictionary *myCare = @{@"title":@"关心",@"vcClass":@"MyCareUserListViewController"};
    NSDictionary *myFans = @{@"title":@"校粉",@"vcClass":@"MyFansUserListViewController"};
    NSDictionary *myPee = @{@"title":@"窥客",@"vcClass":@"MyPeepUserListViewController"};
    NSArray *userArray = @[myCare,myFans,myPee];

    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userArray];
    
    
    CGFloat totalHeight = XXNavContentHeight-49;
    CGFloat totalWidth = self.view.frame.size.width;
    
    //user head view
    _userHeadView = [[MyHomeUserHeadView alloc]initWithFrame:CGRectMake(0,-34,totalWidth,200)];
    [self.view addSubview:_userHeadView];
    
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,200,totalWidth,totalHeight-200) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    [self.view addSubview:guideTable];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.view.frame = CGRectMake(0,0,self.navigationController.view.frame.size.width,self.navigationController.view.frame.size.height);
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return guideVCArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[guideVCArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseIconLabelCountCell *cell = (XXBaseIconLabelCountCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXBaseIconLabelCountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"title"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    NSString *VCName = [item objectForKey:@"vcClass"];
    Class newVC = NSClassFromString(VCName);
    
    UIViewController *pushVC = [[newVC alloc]init];
    pushVC.title = [item objectForKey:@"title"];
    
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

@end
