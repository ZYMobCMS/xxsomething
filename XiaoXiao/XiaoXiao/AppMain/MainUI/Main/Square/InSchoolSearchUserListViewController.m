//
//  InSchoolSearchUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "InSchoolSearchUserListViewController.h"

@interface InSchoolSearchUserListViewController ()

@end

@implementation InSchoolSearchUserListViewController

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
    self.title = @"校内人";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];

    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - overload
- (void)refresh
{
    _hiddenLoadMore = NO;
    _isRefresh = YES;
    _currentPageIndex = 0;
    [self requestUserList];
}
- (void)requestUserList
{
    //校内人搜索
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.schoolId = [XXUserDataCenter currentLoginUser].schoolId;
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    [[XXMainDataCenter shareCenter]requestSameSchoolUsersWithCondition:condition withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        if (_isRefresh) {
            [_userListArray removeAllObjects];
            _isRefresh = NO;
            [_refreshControl endRefreshing];
        }
        [_userListArray addObjectsFromArray:resultList];
        [_userListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestUserList];
}


@end
