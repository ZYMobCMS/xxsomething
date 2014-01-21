//
//  TeaseMeListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "TeaseMeListViewController.h"
#import "XXTeaseBaseCell.h"

@interface TeaseMeListViewController ()

@end

@implementation TeaseMeListViewController

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
    _teasesArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44-49-40;
    _teaseListTable = [[UITableView alloc]init];
    _teaseListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _teaseListTable.delegate = self;
    _teaseListTable.dataSource = self;
    _teaseListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _teaseListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_teaseListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_teaseListTable addSubview:_refreshControl];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teasesArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXTeaseBaseCell *cell = (XXTeaseBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXTeaseBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setContentModel:[_teasesArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - override api
- (void)requestTeaseMeListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.userId = [XXUserDataCenter currentLoginUser].userId;
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    
    [[XXMainDataCenter shareCenter]requestTeaseMeListWithCondition:condition withSuccess:^(NSArray *resultList) {
       
        if (_isRefresh) {
            [_teasesArray removeAllObjects];
        }
        [_teasesArray addObjectsFromArray:resultList];
        [_teaseListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _hiddenLoadMore = NO;
    _isRefresh = YES;
    [self requestTeaseMeListNow];
}
- (void)loadMoreResult
{
    
}


@end
