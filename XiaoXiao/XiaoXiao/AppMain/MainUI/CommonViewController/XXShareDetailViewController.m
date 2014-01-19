//
//  XXShareDetailViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXShareDetailViewController.h"
#import "OtherUserHomeViewController.h"
#import "XXLoadMoreCell.h"

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
    _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight-35);
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
    //is self
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    if ([basePost.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        _chatToolBar.hidden = YES;
    }
    
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
    }else if (indexPath.row==self.commentModelArray.count-1){
        static NSString *CommentIdentifier = @"MoreIdentifier";
        XXLoadMoreCell *cell = (XXLoadMoreCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXLoadMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
        }
        [cell setTitle:[[self.commentModelArray objectAtIndex:indexPath.row]objectForKey:@"title"]];
        
        return cell;
    }else{
       static NSString *CommentIdentifier = @"CommentIdentifier";
        XXCommentCell *cell = (XXCommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
            [cell setCellType:XXBaseCellTypeMiddel];
        }
        
        [cell setCommentModel:[self.commentModelArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.commentModelArray.count-1) {
        return 46.f;
    }else{
        NSNumber *heightNumb = [self.commentRowHeightArray objectAtIndex:indexPath.row];
        return [heightNumb floatValue];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.commentModelArray.count>1&& indexPath.row== self.commentModelArray.count-1) {
        NSDictionary *stateDict = [self.commentModelArray objectAtIndex:indexPath.row];
        if ([[stateDict objectForKey:@"state"]boolValue]) {
            [self loadMoreResult];
        }
    }
}

#pragma mark - config comment bar
- (void)configChatToolBar
{
    
    XXSharePostModel *basePostModel = [self.commentModelArray objectAtIndex:0];
    WeakObj(_hud) weakHud = _hud;
    [_chatToolBar setChatToolBarDidRecord:^(NSString *recordUrl, NSString *amrUrl, NSString *timeLength) {
        
        DDLogVerbose(@"record time length:%@",timeLength);
        weakHud.labelText = @"正在发表...";
        [weakHud show:YES];
        NSData *amrFileData = [NSData dataWithContentsOfFile:amrUrl];
        [[XXMainDataCenter shareCenter]uploadFileWithData:amrFileData withFileName:@"comment.amr" withUploadProgressBlock:^(CGFloat progressValue) {
            
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            XXCommentModel *newComment = [[XXCommentModel alloc]init];
            newComment.postAudioTime = timeLength;
            newComment.postAudio = resultModel.link;
            newComment.rootCommentId = basePostModel.postId;
            newComment.resourceId = basePostModel.postId;
            newComment.resourceType = @"posts";
            
            [[XXMainDataCenter shareCenter]requestPublishCommentWithConditionComment:newComment withSuccess:^(XXCommentModel *resultModel) {
                [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
    
    //send text comment
    [_chatToolBar setChatToolBarTapSend:^(NSString *textContent) {
       
        XXCommentModel *newComment = [[XXCommentModel alloc]init];
        newComment.postAudioTime = @"0";
        newComment.postContent = textContent;
        newComment.rootCommentId = basePostModel.postId;
        newComment.resourceId = basePostModel.postId;
        newComment.resourceType = @"posts";

        weakHud.labelText = @"正在发表...";
        [weakHud show:YES];
        [[XXMainDataCenter shareCenter]requestPublishCommentWithConditionComment:newComment withSuccess:^(XXCommentModel *resultModel) {
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        } withFaild:^(NSString *faildMsg) {
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
    condition.resType = @"posts";
    
    [[XXMainDataCenter shareCenter]requestCommentListWithCondition:condition withSuccess:^(NSArray *resultList) {
        if (self.commentModelArray.count>1) {
            [self.commentModelArray removeLastObject];
        }
        [self.commentModelArray addObjectsFromArray:resultList];
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat commentHeight = [XXCommentCell heightForCommentModel:obj forWidth:_tableView.frame.size.width];
            NSNumber *commentHeightNumb = [NSNumber numberWithFloat:commentHeight];
            [self.commentRowHeightArray addObject:commentHeightNumb];
        }];
        if (resultList.count<_pageSize) {
            if (self.commentModelArray.count==0) {
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"还没有评论"};
                [self.commentModelArray addObject:loadmoreDict];
            }else{
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"没有更多评论"};
                [self.commentModelArray addObject:loadmoreDict];
            }
            
        }else{
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多评论"};
            [self.commentModelArray addObject:loadmoreDict];
        }
        [_tableView reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        if (self.commentModelArray.count==1) {
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多评论"};
            [self.commentModelArray addObject:loadmoreDict];
            [_tableView reloadData];
        }
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
