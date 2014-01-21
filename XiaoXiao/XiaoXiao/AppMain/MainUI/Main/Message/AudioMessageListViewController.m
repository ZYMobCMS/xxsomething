//
//  AudioMessageListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "AudioMessageListViewController.h"

@interface AudioMessageListViewController ()

@end

@implementation AudioMessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMessageListNow
{
    [[XXChatCacheCenter shareCenter]getLatestMessageListWithFinish:^(NSArray *resultArray) {
       
        [_messagesArray addObjectsFromArray:resultArray];
        [_messageListTable reloadData];
        DDLogVerbose(@"_message array:%@",_messagesArray);
    }];
}
- (void)refresh
{
    [self requestMessageListNow];
}
@end
