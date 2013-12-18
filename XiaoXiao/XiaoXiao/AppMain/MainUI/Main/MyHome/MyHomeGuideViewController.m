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
    
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,80,self.view.frame.size.width,self.view.frame.size.height-80) style:UITableViewStyleGrouped];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    [self.view addSubview:guideTable];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
