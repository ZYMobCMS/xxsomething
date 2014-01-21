//
//  XXChatViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"
#import "XXChatToolBar.h"
#import "XXUserModel.h"
#import "XXConditionModel.h"

/*
 *基础聊天视图列表
 */

@interface XXChatViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_messageListTable;
    NSMutableArray *_messagesArray;
    NSMutableArray *_rowHeightArray;
    
    XXChatToolBar *_chatToolBar;
    UIControl        *_whiteBoard;
    
    XXUserModel   *_chatUser;
    NSString      *_isFirstChat;
    XXConditionModel *_conversationCondition;
    
}

- (id)initWithChatUser:(XXUserModel*)chatUser;

@end
