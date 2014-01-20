//
//  XXChatViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatViewController.h"
#import "XXChatCell.h"

@interface XXChatViewController ()

@end

@implementation XXChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithChatUser:(XXUserModel *)chatUser
{
    if (self = [super init]) {
        
        _chatUser = chatUser;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //read cache msg
    _conversationCondition = [[XXConditionModel alloc]init];
    _conversationCondition.userId = [XXUserDataCenter currentLoginUser].userId;
    _conversationCondition.toUserId = _chatUser.userId;

    CGFloat totalHeight = XXNavContentHeight -44;
    _messageListTable = [[UITableView alloc]init];
    _messageListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight-35);
    _messageListTable.delegate = self;
    _messageListTable.dataSource = self;
    _messageListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageListTable];
    
    DDLogVerbose(@"self view frame :%@",NSStringFromCGRect(self.view.frame));
    //tool bar
    _chatToolBar = [[XXChatToolBar alloc]initWithFrame:CGRectMake(0,totalHeight-35,self.view.frame.size.width,35) forUse:XXChatToolBarComment];
    [self.view addSubview:_chatToolBar];
    
    DDLogVerbose(@"toobar frame:%@",NSStringFromCGRect(_chatToolBar.frame));
    self.view.keyboardTriggerOffset = _chatToolBar.bounds.size.height;
    
    WeakObj(_chatToolBar) weakToolBar = _chatToolBar;
    WeakObj(_messageListTable) weakMsgTable = _messageListTable;
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
        
        DDLogVerbose(@"keyborad :%@",NSStringFromCGRect(keyboardFrameInView));
        CGRect toolBarFrame = weakToolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakToolBar.frame = toolBarFrame;
        
        CGRect tableFrame = weakMsgTable.frame;
        weakMsgTable.frame = CGRectMake(tableFrame.origin.x,tableFrame.origin.y,tableFrame.size.width,keyboardFrameInView.origin.y);

        
    }];
    
    _conversationCondition.pageIndex = StringInt(0);
    _conversationCondition.pageSize = StringInt(10);
    [[XXChatCacheCenter shareCenter]readCacheMsgToDictForCondition:_conversationCondition withFinish:^(NSArray *messages) {
       
        DDLogVerbose(@"cache mssages:%@",messages);
        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            ZYXMPPMessage *eachMsg = (ZYXMPPMessage *)obj;
            CGFloat height = [XXChatCell heightWithXMPPMessage:eachMsg forWidth:_messageListTable.frame.size.width];
            [_rowHeightArray addObject:[NSNumber numberWithFloat:height]];
            
            [_messageListTable reloadData];
        }];
        
    }];
    
    [self configChatToolBar];
    [self configMessageAction];
    
    //observe keyobard
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[XXChatCacheCenter shareCenter]messagesFromCacheDictForConversationCondition:_conversationCondition].count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXChatCell *cell = (XXChatCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ZYXMPPMessage *aMessage = [[[XXChatCacheCenter shareCenter]messagesFromCacheDictForConversationCondition:_conversationCondition]objectAtIndex:indexPath.row];
    [cell setXMPPMessage:aMessage];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *rowHeight = [_rowHeightArray objectAtIndex:indexPath.row];
    return [rowHeight floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - config comment bar
- (void)configChatToolBar
{
    
    WeakObj(_hud) weakHud = _hud;
    [_chatToolBar setChatToolBarDidRecord:^(NSString *recordUrl, NSString *amrUrl, NSString *timeLength) {
        
        DDLogVerbose(@"record time length:%@",timeLength);
        weakHud.labelText = @"正在发表...";
        [weakHud show:YES];
        NSData *amrFileData = [NSData dataWithContentsOfFile:amrUrl];
        [[XXMainDataCenter shareCenter]uploadFileWithData:amrFileData withFileName:@"comment.amr" withUploadProgressBlock:^(CGFloat progressValue) {
            
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
    
    //send text comment
    WeakObj(_chatUser) weakChatUser = _chatUser;
    NSString *myUserId = [XXUserDataCenter currentLoginUser].userId;
    NSString *myUserName = [XXUserDataCenter currentLoginUser].nickName;
    WeakObj(_messageListTable) weakMsgTable = _messageListTable;
    WeakObj(_rowHeightArray) weakRowHeight = _rowHeightArray;
    WeakObj(_conversationCondition) weakCondition = _conversationCondition;

    [_chatToolBar setChatToolBarTapSend:^(NSString *textContent) {
        
        ZYXMPPUser *newUser = [[ZYXMPPUser alloc]init];
        newUser.jID = weakChatUser.userId;
        ZYXMPPMessage *message = [[ZYXMPPMessage alloc]init];
        message.content = textContent;
        message.user = myUserName;
        message.audioTime = @"0";
        message.userId = myUserId;
        message.sendStatus = @"0";
        message.isReaded = @"1";
        message.conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:newUser.jID withMyUserId:message.userId];
        message.messageType = [NSString stringWithFormat:@"%d",ZYXMPPMessageTypeText];
        message.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:message];
        
        [[ZYXMPPClient shareClient]  sendMessageToUser:newUser withContent:message withSendResult:^(NSString *messageId, NSString *addTime) {
            message.messageId = messageId;
            message.addTime = addTime;
            if (message.messageId) {
                //发消息肯定在前台，所以存入内存缓存中
                [[XXChatCacheCenter shareCenter]saveMessageForCacheDict:message];
                CGFloat messageHeight = [XXChatCell heightWithXMPPMessage:message forWidth:weakMsgTable.frame.size.width];
                [weakRowHeight addObject:[NSNumber numberWithFloat:messageHeight]];
                [weakMsgTable reloadData];
                
                NSArray *cacheDictMsgArray = [[XXChatCacheCenter shareCenter]messagesFromCacheDictForConversationCondition:weakCondition];
                DDLogVerbose(@"messages:%@",cacheDictMsgArray);
            }
        }];

    }];
}

- (void)configMessageAction
{
    [[ZYXMPPClient shareClient]setSendMessageSuccessAction:^(ZYXMPPMessage *message, ZYXMPPUser *toUser) {
    
    } forReciever:self];
    
    [[ZYXMPPClient shareClient]setDidRecievedMessage:^(ZYXMPPMessage *newMessage) {
        
        newMessage.isFromSelf = NO;
        if (newMessage.messageId) {
            //这里肯定在前台，所以存入内存缓存中
            [[XXChatCacheCenter shareCenter]saveMessageForCacheDict:newMessage];
            CGFloat messageHeight = [XXChatCell heightWithXMPPMessage:newMessage forWidth:_messageListTable.frame.size.width];
            [_rowHeightArray addObject:[NSNumber numberWithFloat:messageHeight]];
        }
        [_messageListTable reloadData];
        
    } forReciever:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    //保存所有信息
    [[XXChatCacheCenter shareCenter]persistMessagesWithCondition:_conversationCondition];
    
    [[ZYXMPPClient shareClient]removeMsgActionForReciever:self];
}

@end
