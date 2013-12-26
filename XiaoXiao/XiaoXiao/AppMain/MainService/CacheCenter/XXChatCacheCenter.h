//
//  XXChatCacheCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-26.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ZYXMPPMessage.h"

@interface XXChatCacheCenter : NSObject
{
    FMDatabase *_innerDataBase;
    FMResultSet *_resultSet;
}
+ (XXChatCacheCenter*)shareCenter;
- (void)saveMessage:(ZYXMPPMessage*)newMessage;
- (void)saveSomeMessages:(NSArray*)messages;
- (void)updateMessageSendStatusWithMessageId:(NSString*)messageId;
- (NSArray*)getCacheMessagesWithCondition:(XXConditionModel*)condition;
@end
