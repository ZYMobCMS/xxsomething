//
//  XXChatCacheCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-26.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatCacheCenter.h"

#define XXChatMessageCacheDirectory @"xxchat_message_cache"
#define XXChatMessageDataBase       @"xxchat_db"

//conversation_id标示对话的id，用谈话对象的id和自己的id加下划线组成，这个是唯一的  别人的Id_自己的Id
#define XXChatMessageTableCreate @"create table xxchat_table(send_user_id text,status text,send_user text,add_time text,audio_time text,body_content text,message_type text,is_readed text,message_id text primary key,conversation_id text)"

@implementation XXChatCacheCenter
- (id)init
{
    if (self = [super init]) {
        [self openDataBase];
    }
    return self;
}
+ (XXChatCacheCenter*)shareCenter
{
    static XXChatCacheCenter *_chatCache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_chatCache) {
            _chatCache = [[XXChatCacheCenter alloc]init];
        }
    });
    return _chatCache;
}
- (void)dealloc{
    [_innerDataBase close];
}
- (void)openDataBase
{
    NSArray *rootPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *rootPath = [rootPaths lastObject];
    NSString *chatDBDir = [rootPath stringByAppendingPathComponent:XXChatMessageCacheDirectory];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDBDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:chatDBDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *chatDB = [chatDBDir stringByAppendingPathComponent:XXChatMessageDataBase];
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDB]) {
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
        NSError *createTableError = nil;
        [_innerDataBase update:XXChatMessageTableCreate withErrorAndBindings:&createTableError];
        if (createTableError) {
            DDLogVerbose(@"create table error:%@",createTableError);
        }
    }else{
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
    }
    
}

- (void)saveMessage:(ZYXMPPMessage*)newMessage
{
    NSString *insertSql = [NSString stringWithFormat:@"insert into xxchat_table(send_user_id,status,send_user,add_time,audio_time,body_content,message_type,is_readed,message_id,conversation_id)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",newMessage.userId,newMessage.sendStatus,newMessage.user,newMessage.addTime,newMessage.audioTime,newMessage.content,newMessage.messageType,newMessage.isReaded,newMessage.messageId,newMessage.conversationId];
    DDLogVerbose(@"save message sql :%@",insertSql);
    NSError *saveMessageError = nil;
    BOOL saveResult = [_innerDataBase update:insertSql withErrorAndBindings:&saveMessageError];
    DDLogVerbose(@"save message result:%d",saveResult);
    if (saveMessageError) {
        DDLogVerbose(@"save message error:%@",saveMessageError);
    }
}

- (void)saveSomeMessages:(NSArray*)messages
{
    dispatch_async(dispatch_get_current_queue(), ^{
        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ZYXMPPMessage *aMsg = (ZYXMPPMessage*)obj;
            [self saveMessage:aMsg];
        }];
    });
}

- (void)updateMessageSendStatusWithMessageId:(NSString *)messageId
{
    NSString *updateSql = [NSString stringWithFormat:@"update xxchat_table set status = '1' where message_id='%@'",messageId];
    NSError *updateMsgError = nil;
    BOOL updateResult = [_innerDataBase update:updateSql withErrorAndBindings:&updateMsgError];
    DDLogVerbose(@"update message result:%d",updateResult);
    if (updateMsgError) {
        DDLogVerbose(@"update message error:%@",updateMsgError);
    }
}

- (NSArray*)getCacheMessagesWithCondition:(XXConditionModel*)condition
{
    if (!condition.userId||!condition.toUserId) {
        DDLogVerbose(@"query cache message need two user id to find conversation");
        return nil;
    }
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.userId withMyUserId:condition.toUserId];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from xxchat_table where conversation_id='%@' limit %d,%d",conversationId,[condition.pageIndex intValue],[condition.pageSize intValue]];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    while ([resultSet next]) {
        
        ZYXMPPMessage *existMsg = [[ZYXMPPMessage alloc]init];
        existMsg.messageId = [resultSet stringForColumn:@"message_id"];
        existMsg.content = [resultSet stringForColumn:@"body_content"];
        existMsg.conversationId = [resultSet stringForColumn:@"conversation_id"];
        existMsg.userId = [resultSet stringForColumn:@"send_user_id"];
        existMsg.user = [resultSet stringForColumn:@"send_user"];
        existMsg.sendStatus = [resultSet stringForColumn:@"status"];
        existMsg.addTime = [resultSet stringForColumn:@"add_time"];
        existMsg.audioTime = [resultSet stringForColumn:@"audio_time"];
        existMsg.messageType = [resultSet stringForColumn:@"message_type"];
        existMsg.isReaded = [resultSet stringForColumn:@"is_readed"];
        
        [modelArray addObject:existMsg];
    }
    return modelArray;
    
}

@end