//
//  XXBaseUserListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *通用用户列表
 */

@interface XXBaseUserListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_userListTable;
    NSMutableArray *_userListArray;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    
}

- (void)refresh;
- (void)requestUserList;
- (void)loadMoreResult;
- (void)finishRequestWithResultArray:(NSArray*)resultArray;

@end
