//
//  UITestViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL backgroundRecieveMsg;
    XXBaseTextView *messageShowTextView;
}
@property (nonatomic,strong)UITableView *testTable;
@property (nonatomic,strong)NSMutableArray *sourceArray;

@end
