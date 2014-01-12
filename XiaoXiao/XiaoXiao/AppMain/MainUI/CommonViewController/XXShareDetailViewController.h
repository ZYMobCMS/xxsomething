//
//  XXShareDetailViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCommentCell.h"
#import "XXChatToolBar.h"

@interface XXShareDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    
    XXChatToolBar *_toolBar;
}
@property (nonatomic,strong)NSMutableArray *commentModelArray;
@property (nonatomic,strong)NSMutableArray *commentRowHeightArray;

- (id)initWithSharePost:(XXSharePostModel*)aSharePost;

- (void)requestCommentListNow;
- (void)refresh;
- (void)loadMoreResult;

@end
