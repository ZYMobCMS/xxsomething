//
//  XXShareDetailViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXShareDetailViewController.h"

@interface XXShareDetailViewController ()

@end

@implementation XXShareDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSharePost:(XXSharePostModel *)aSharePost
{
    if (self = [super init]) {
        
        //
        self.commentModelArray = [[NSMutableArray alloc]init];
        self.commentRowHeightArray = [[NSMutableArray alloc]init];
        
        [self.commentModelArray addObject:aSharePost];
        CGFloat postHeight = [XXShareBaseCell heightWithSharePostModelForDetail:aSharePost forContentWidth:[XXSharePostStyle sharePostContentWidth]];
        [self.commentRowHeightArray addObject:[NSNumber numberWithFloat:postHeight]];
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"说说详情";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44;
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //tool bar
    _toolBar = [[XXChatToolBar alloc]initWithFrame:CGRectMake(0,totalHeight-35,self.view.frame.size.width,35) forUse:XXChatToolBarComment];
    [self.view addSubview:_toolBar];
    
    self.view.keyboardTriggerOffset = _toolBar.bounds.size.height;
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
    
        CGRect toolBarFrame = _toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        _toolBar.frame = toolBarFrame;
        
    }];
    
    [self requestCommentListNow];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
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
    return self.commentModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifier ";
        XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setTapOnAudioImageBlock:^(NSURL *audioUrl) {
                DDLogVerbose(@"audioUrl :%@",audioUrl);
                [[XXAudioManager shareManager]audioManagerPlayAudioForRemoteAMRUrl:audioUrl.absoluteString];
            }];
        }
        [cell setSharePostModelForDetail:[self.commentModelArray objectAtIndex:indexPath.row]];
        
        return cell;
    }else{
       static NSString *CommentIdentifier = @"CommentIdentifier";
        XXCommentCell *cell = (XXCommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
        }
        [cell setCommentModel:[self.commentModelArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *heightNumb = [self.commentRowHeightArray objectAtIndex:indexPath.row];
    return [heightNumb floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.commentModelArray.count-1 && _hiddenLoadMore == NO) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        tableView.tableFooterView = loadMoreView;
        [loadMoreView startLoading];
        [self loadMoreResult];
    }else{
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        [loadMoreView setTitle:@"没有评论"];
        tableView.tableFooterView = loadMoreView;
    }
}


#pragma mark - override api
- (void)detailModelArrayAndRowHeightNow
{
    
}

- (void)requestCommentListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    condition.postId = basePost.postId;
    [[XXMainDataCenter shareCenter]requestCommentListWithCondition:condition withSuccess:^(NSArray *resultList) {
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        [self.commentModelArray addObjectsFromArray:resultList];
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat commentHeight = [XXCommentCell heightForCommentModel:obj forWidth:_tableView.frame.size.width];
            NSNumber *commentHeightNumb = [NSNumber numberWithFloat:commentHeight];
            [self.commentRowHeightArray addObject:commentHeightNumb];
        }];
        [_tableView reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)refresh
{
    
}
- (void)loadMoreResult
{
    
}


@end
