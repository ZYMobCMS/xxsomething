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
    self.hidesBottomBarWhenPushed = YES;
    
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
    
    DDLogVerbose(@"self view frame :%@",NSStringFromCGRect(self.view.frame));
    //tool bar
    _chatToolBar = [[XXChatToolBar alloc]initWithFrame:CGRectMake(0,totalHeight-35,self.view.frame.size.width,35) forUse:XXChatToolBarComment];
    [self.view addSubview:_chatToolBar];
    
    DDLogVerbose(@"toobar frame:%@",NSStringFromCGRect(_chatToolBar.frame));
    self.view.keyboardTriggerOffset = _chatToolBar.bounds.size.height;
    
    WeakObj(_chatToolBar) weakToolBar = _chatToolBar;
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
    
        DDLogVerbose(@"keyborad :%@",NSStringFromCGRect(keyboardFrameInView));
        CGRect toolBarFrame = weakToolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakToolBar.frame = toolBarFrame;
        
    }];
    [self configChatToolBar];
    
    //observe keyobard
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    [self requestCommentListNow];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
}

#pragma mark - white board
- (void)keyboardDidShow
{
    if (!_whiteBoard) {
        _whiteBoard = [[UIControl alloc]initWithFrame:self.view.bounds];
        _whiteBoard.alpha = 0;
        _whiteBoard.backgroundColor = [UIColor whiteColor];
        [_whiteBoard addTarget:self action:@selector(touchDownWhiteBoard) forControlEvents:UIControlEventTouchDown];
        [self.view insertSubview:_whiteBoard belowSubview:_chatToolBar];
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0.05;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0.05;
        }];
        
    }
}
- (void)keyboardDidHidden
{
    if (_whiteBoard.alpha!=0.f) {
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0;
        }];
    }
}
- (void)touchDownWhiteBoard
{
    [_chatToolBar reginFirstResponse];
    [UIView animateWithDuration:0.3 animations:^{
        _whiteBoard.alpha = 0;
    }];
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
        loadMoreView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = loadMoreView;
        [loadMoreView startLoading];
        [self loadMoreResult];
    }else{
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        loadMoreView.backgroundColor = [UIColor whiteColor];
        [loadMoreView setTitle:@"没有评论"];
        tableView.tableFooterView = loadMoreView;
    }
}

#pragma mark - config comment bar
- (void)configChatToolBar
{
    
    XXSharePostModel *basePostModel = [self.commentModelArray objectAtIndex:0];
    [_chatToolBar setChatToolBarDidRecord:^(NSString *recordUrl, NSString *amrUrl, NSString *timeLength) {
        
        DDLogVerbose(@"record time length:%@",timeLength);
        [SVProgressHUD showWithStatus:@"正在发表..."];
        NSData *amrFileData = [NSData dataWithContentsOfFile:amrUrl];
        [[XXMainDataCenter shareCenter]uploadFileWithData:amrFileData withFileName:@"comment.amr" withUploadProgressBlock:^(CGFloat progressValue) {
            
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            XXCommentModel *newComment = [[XXCommentModel alloc]init];
            newComment.postAudioTime = timeLength;
            newComment.postAudio = resultModel.link;
            newComment.rootCommentId = basePostModel.postId;
            newComment.resourceId = basePostModel.postId;
            
            
            [[XXMainDataCenter shareCenter]requestPublishCommentWithConditionComment:newComment withSuccess:^(XXCommentModel *resultModel) {
                [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
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