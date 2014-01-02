//
//  XXBaseUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseUserListViewController.h"
#import "XXUserInfoBaseCell.h"

@interface XXBaseUserListViewController ()

@end

@implementation XXBaseUserListViewController

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
    _userListArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    //
    CGFloat totalHeight = self.view.frame.size.height-44;
    _userListTable = [[UITableView alloc]init];
    _userListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _userListTable.delegate = self;
    _userListTable.dataSource = self;
    [self.view addSubview:_userListTable];
    
    ISRefreshControl *refreshControl = [[ISRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [XXCommonStyle xxThemeBlueColor];
    [_userListTable addSubview:refreshControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userListArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXUserInfoBaseCell *cell = (XXUserInfoBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXUserInfoBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setContentModel:[_userListArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _userListArray.count-1 && !_hiddenLoadMore) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
        tableView.tableFooterView = loadMoreView;
        [self loadMoreResult];
        [loadMoreView startLoading];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXUserModel *userModel = [_userListArray objectAtIndex:indexPath.row];
    return [XXUserInfoBaseCell heightWithContentModel:userModel];
}
#pragma mark - over load method
- (void)requestUserList
{
    
}
- (void)finishRequestWithResultArray:(NSArray *)resultArray
{
    
}
- (void)loadMoreResult
{
    
}
- (void)refresh
{
    
}

@end
