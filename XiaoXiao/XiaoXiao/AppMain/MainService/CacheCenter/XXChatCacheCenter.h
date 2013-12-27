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
    
    //内存缓存
    NSMutableDictionary *_innerCacheDict;
}
+ (XXChatCacheCenter*)shareCenter;
- (void)saveMessage:(ZYXMPPMessage*)newMessage;
- (void)saveSomeMessages:(NSArray*)messages;
- (void)updateMessageSendStatusWithMessageId:(NSString*)messageId;
- (void)getCacheMessagesWithCondition:(XXConditionModel*)condition withFinish:(void(^)(NSArray*resultArray))finish;
- (void)getUnReadMessagesWithCondition:(XXConditionModel*)condition withFinish:(void(^)(NSArray*resultArray))finish;


//内存运行缓存
- (void)saveMessageForCacheDict:(ZYXMPPMessage*)newMessage;
- (void)saveSomeMessagesForCacheDict:(NSArray*)messages;
- (void)updateMessageSendStatusWithMessageIdForCacheDict:(NSString*)messageId;
- (void)persistMessagesWithCondition:(XXConditionModel*)condition;
@end
