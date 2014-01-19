//
//  XXMessageListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *通用消息列表
 */
@interface XXMessageListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_messageListTable;
    UIRefreshControl *_refreshControl;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    BOOL        _isRefresh;
    
    NSMutableArray *_messagesArray;
}

- (void)requestShareListNow;
- (void)refresh;
- (void)loadMoreResult;

@end
