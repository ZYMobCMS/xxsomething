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
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":@"333",@"title":@"相册",@"vcClass":@"MyShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    NSDictionary *myCare = @{@"icon":@"my_home_care.png",@"count":@"333",@"title":@"关心",@"vcClass":@"MyCareUserListViewController"};
    NSDictionary *myFans = @{@"icon":@"my_home_fans.png",@"count":@"333",@"title":@"校粉",@"vcClass":@"MyFansUserListViewController"};
    NSDictionary *myPee = @{@"icon":@"my_home_peer.png",@"count":@"333",@"title":@"窥客",@"vcClass":@"MyPeepUserListViewController"};
    NSArray *userArray = @[myCare,myFans,myPee];

    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userArray];
    
    CGFloat originY = IS_IOS_7? 20:0;
    CGFloat totalHeight = XXNavContentHeight+originY;
    CGFloat totalWidth = self.view.frame.size.width;
    
    CGFloat headViewHeight = 250;
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,headViewHeight,totalWidth,totalHeight-headViewHeight) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    guideTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    guideTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guideTable];
    
    //user head view

    _userHeadView = [[MyHomeUserHeadView alloc]initWithFrame:CGRectMake(0,originY,totalWidth,headViewHeight)];
    _userHeadView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_userHeadView];
    _userHeadView.layer.shadowOffset = CGSizeMake(0,0.3);
    _userHeadView.layer.shadowColor = [UIColor blackColor].CGColor;
    _userHeadView.layer.shadowOpacity = 0.2f;
    [_userHeadView setContentUser:[XXUserDataCenter currentLoginUser]];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
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
    XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
    }else if(indexPath.section==1&&indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
    }else if(indexPath.section==1&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
    }
    NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setContentDict:item];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 20.f;
    }else{
        return 30.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 47;
    }else if(indexPath.section==1){
        
        if (indexPath.row == [[guideVCArray objectAtIndex:indexPath.section]count]-1) {
            return 46.5;
        }else if(indexPath.row == 0){
            return 46;
        }else{
            return 45.5;
        }
    }else{
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 20.f;
    }else{
        return 0.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    NSString *VCName = [item objectForKey:@"vcClass"];
    Class newVC = NSClassFromString(VCName);
    
    UIViewController *pushVC = [[newVC alloc]init];
    pushVC.title = [item objectForKey:@"title"];
    [self.navigationController pushViewController:pushVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:pushVC];
}

@end
