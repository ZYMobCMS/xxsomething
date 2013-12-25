//
//  ZYXMPPMessage.h
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ZYXMPPMessageTypeText=0,     //0
    ZYXMPPMessageTypeImage,      //1
    ZYXMPPMessageTypeAudio,      //2
    
}ZYXMPPMessageType;

/*
 message 内容，需要添加，录音的话需要增加录音的长度描述
 用 body 作为标记   :文本聊天内容
 用 audio_time 作为 xml的元素标记名 :这条语音信息的时间长度
 用 add_time 作为xml的元素标记名  ：这条信息的发送时间
 用 message_type 作为标记   :标记 body字段放的什么内容
 用 send_user 作为标记      :标记 是谁发的,取用户昵称
 用 send_user_id 作为标记   :标记 发送用户在校校系统中的user_id,也就是openfire注册的id，是相同的
 */

@interface ZYXMPPMessage : NSObject
@property (nonatomic,strong)NSString *user;
@property (nonatomic,strong)NSString *domain;
@property (nonatomic,strong)NSString *resource;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *addTime;
@property (nonatomic,strong)NSString *audioTime;
@property (nonatomic,strong)NSString *messageType;
@property (nonatomic,strong)NSString *userId;

@end