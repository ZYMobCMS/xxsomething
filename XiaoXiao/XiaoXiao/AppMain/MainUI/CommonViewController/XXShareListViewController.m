//
//  XXShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareListViewController.h"
#import "XXShareDetailViewController.h"

@interface XXShareListViewController ()

@end

@implementation XXShareListViewController
@synthesize sharePostModelArray,sharePostRowHeightArray;

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
    self.sharePostRowHeightArray = [[NSMutableArray alloc]init];
    self.sharePostModelArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    _shareListTable = [[UITableView alloc]init];
    _shareListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _shareListTable.delegate = self;
    _shareListTable.dataSource = self;
    _shareListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _shareListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_shareListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_shareListTable addSubview:_refreshControl];
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
    return self.sharePostModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSharePostModel:[self.sharePostModelArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *heightNumb = [self.sharePostRowHeightArray objectAtIndex:indexPath.row];
    return [heightNumb floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:shareDetail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.sharePostModelArray.count-1 && _hiddenLoadMore == NO) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        tableView.tableFooterView = loadMoreView;
        [loadMoreView startLoading];
        [self loadMoreResult];
    }
}

#pragma mark - override api
- (void)detailModelArrayAndRowHeightNow
{
    
}

- (void)requestShareListNow
{
    
}
- (void)refresh
{
    
}
- (void)loadMoreResult
{
    
}

@end
