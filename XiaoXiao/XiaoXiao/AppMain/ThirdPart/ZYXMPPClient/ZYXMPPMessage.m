//
//  ZYXMPPMessage.m
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPMessage.h"

@implementation ZYXMPPMessage
- (id)init
{
    if (self = [super init]) {
        
        self.content = @"";
        self.sendStatus = @"0";
        self.user = @"";
        self.userId = @"";
        self.messageId = @"";
        self.messageType = @"";
        self.addTime = @"";
        self.audioTime = @"";
        self.groupRoomId = @"";
        self.isReaded = @"0";
    }
    return self;
}
+ (NSString*)conversationIdWithOtherUserId:(NSString *)oId withMyUserId:(NSString *)myId
{
    return [NSString stringWithFormat:@"%@_%@",oId,myId];
}
+ (NSAttributedString*)attributedContentStringWithMessage:(ZYXMPPMessage *)aMessage
{
    return [XXBaseTextView formatteCommonTextToAttributedText:aMessage.content];
}
@end
