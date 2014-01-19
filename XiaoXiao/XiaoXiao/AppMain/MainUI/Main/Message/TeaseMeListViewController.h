//
//  TeaseMeListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeaseMeListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_teaseListTable;
    UIRefreshControl *_refreshControl;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    BOOL        _isRefresh;
    
    NSMutableArray *_teasesArray;
}

@end
