//
//  XXChatCacheCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-26.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ZYXMPPMessage.h"

#define XXChatMessageCacheDirectory @"xxchat_message_cache"
#define XXChatMessageTableCreate @"create table xxchat_table(id primary,status,send_user_id,send_user,content,add_time,audio_time,body_content,message_type)"

@interface XXChatCacheCenter : NSObject
+ (XXChatCacheCenter*)shareCenter;
+ (void)saveMessage:(ZYXMPPMessage*)newMessage;
+ (void)saveSomeMessages:(NSArray*)messages;
+ (NSArray*)getCacheMessagesWithCondition:(XXConditionModel*)condition;
@end
