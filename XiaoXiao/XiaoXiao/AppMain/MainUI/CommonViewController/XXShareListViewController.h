//
//  XXShareListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *通用分享列表
 */

@interface XXShareListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *shareListTable;
}
@property (nonatomic,strong)NSMutableArray *sharePostModelArray;
@property (nonatomic,strong)NSMutableArray *sharePostRowHeightArray;

- (void)requestShareListNow;

@end
