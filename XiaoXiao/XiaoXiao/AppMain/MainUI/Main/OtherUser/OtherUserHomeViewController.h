//
//  OtherUserHomeViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *guideTable;
    
    NSMutableArray *guideVCArray;

    XXUserModel *_currentUser;
}

- (id)initWithContentUser:(XXUserModel*)aUser;

@end
