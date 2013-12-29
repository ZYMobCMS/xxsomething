//
//  ZYXMPPClient.m
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPClient.h"

@interface ZYXMPPClient()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

#define kZYXMPPRoom @"kZYXMPPRoom"
#define kZYXMPPRoomStorge @"kZYXMPPRoomStorge"
#define kZYXMPPRoomMembers @"kZYXMPPRoomMembers"

@implementation ZYXMPPClient
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize hasConfigedClient;
@synthesize xmppRoom;

#pragma mark - init 
- (id)init
{
    if (self = [super init]) {
        
        _actions = [[NSMutableDictionary alloc]init];
        xmppRooms = [[NSMutableDictionary alloc]init];
        _innerConfigDict = [[NSMutableDictionary alloc]init];
        [self initDefaultRoomConfig];
        needBackgroundRecieve = YES;//默认后台接收消息
        // Setup the XMPP stream
        [self setupStream];
    }
    return self;
}

+ (ZYXMPPClient*)shareClient
{
    static ZYXMPPClient *chatClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!chatClient) {
            chatClient = [[ZYXMPPClient alloc]init];
        }
    });
    return chatClient;
}

- (void)dealloc
{
	[self teardownStream];
}
//是否需要补全JID
- (void)setNeedAutoJIDWithCustomHostName:(BOOL)state
{
    needAutoHostForJID = state;
}

#pragma mark - start client
- (void)startClientWithJID:(NSString *)jidString withPassword:(NSString *)password
{
    if (!jidString || !password) {
        ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
        faildAction(@"jid or password is null !");
        return;
    }
    
    if (isXmppConnected) {
        return;
    }
    if ([xmppStream isConnected]) {
        return;
    }
    
    _jId = jidString;
    originJId = jidString;
    if (needAutoHostForJID) {
        _jId = [NSString stringWithFormat:@"%@@%@",_jId,_serverHost];
    }
    _password = password;

    myRoomConfig.roomID = [self genrateRoomID];
    myRoomConfig.myNickName = [NSString stringWithFormat:@"%@",originJId];
    myRoomConfig.name = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.description = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.subject = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.owner = _jId;
    
    if (![self connect])
	{
		if ([_actions objectForKey:@"clientStartFaild"]) {
            
            ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
            faildAction(@"client start faild");
        }
	}else{
        if ([_actions objectForKey:@"clientStartSuccess"]) {
            
            ZYXMPPClientStartSuccessAction successAction = [_actions objectForKey:@"clientStartSuccess"];
            successAction(@"client start success");
            [self goOnline];
        }
    }
}
- (void)clientTearDown
{
    [self disconnect];
    [self teardownStream];
}
- (void)setJabbredServerAddress:(NSString *)address
{
    _serverHost = address;
}
- (void)setNeedBackgroundRecieve:(BOOL)needBackground
{
    if (needBackground==needBackgroundRecieve) {
        return;
    }
    needBackgroundRecieve = needBackground;
}
- (BOOL)backgroundActiveEnbaleState
{
    return needBackgroundRecieve;
}
- (void)setNeedUseCustomHostAddress:(BOOL)shouldUse
{
    shouldUseCustomHost = shouldUse;
}
- (void)setStartClientSuccessAction:(ZYXMPPClientStartSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"clientStartSuccess"];
}
- (void)setStartClientFaildAction:(ZYXMPPClientStartFaildAction)faildAction
{
    [_actions setObject:faildAction forKey:@"clientStartFaild"];
}
- (void)setConnectToServerErrorAction:(ZYXMPPClientConnectServerErrorAction)errorAction
{
    [_actions setObject:errorAction forKey:@"connectServerError"];
}
- (void)setSendMessageSuccessAction:(ZYXMPPClientSendMessageSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"sendMessageSuccess"];
}
- (void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction
{
    [_actions setObject:faildAction forKey:@"sendMessageFaild"];
}
- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction
{
    [_actions setObject:recievedAction forKey:@"recieveMessageSuccess"];
}
- (void)setDidSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"didSendMessageSuccess"];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Send  Message  and Recieve Message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//返回当前时间
- (NSString*)returnCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-M-d HH:i:s"];
    
    NSString *currentDateTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateTime;
}
- (void)sendMessageToUser:(ZYXMPPUser *)toUser withContent:(ZYXMPPMessage *)newMessage withSendResult:(void (^)(NSString *, NSString *))sendResult
{

    if (needAutoHostForJID) {
        toUser.jID = [NSString stringWithFormat:@"%@@%@",toUser.jID,_serverHost];
    }
	if([newMessage.content length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:newMessage.content];
        NSXMLElement *messageType = [NSXMLElement elementWithName:@"message_type"];
        [messageType setStringValue:newMessage.messageType];
        NSXMLElement *sendUser = [NSXMLElement elementWithName:@"send_user"];
        [sendUser setStringValue:newMessage.user];
        NSXMLElement *sendUserId = [NSXMLElement elementWithName:@"send_user_id"];
        [sendUserId setStringValue:newMessage.userId];
        NSXMLElement *addTime = [NSXMLElement elementWithName:@"add_time"];
        NSString *currentTime = [self returnCurrentDateTime];
		[addTime setStringValue:currentTime];
        if (![newMessage.content isEqualToString:@""]) {
            newMessage.audioTime = @"0";
        }
        NSXMLElement *audioTime = [NSXMLElement elementWithName:@"audio_time"];
        [audioTime setStringValue:newMessage.audioTime];
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];

        NSString *siID = [XMPPStream generateUUID];
        XMPPJID *receiptUser = [XMPPJID jidWithString:toUser.jID];
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:receiptUser elementID:siID];
		[message addAttributeWithName:@"type" stringValue:@"chat"];
		[message addAttributeWithName:@"to" stringValue:toUser.jID];
		[message addChild:body];
        [message addChild:messageType];
        [message addChild:sendUser];
        [message addChild:sendUserId];
        [message addChild:addTime];
        [message addChild:audioTime];
        [message addChild:receipt];
        
        DDLogVerbose(@"send message once time!");
        [self.xmppStream sendElement:message];
        
        //将这条信息的Id返回，以判断是否发送成功
        if ([message attributeStringValueForName:@"id"]) {
            DDLogVerbose(@"send message id :%@",[message attributeStringValueForName:@"id"]);
            if (sendResult) {
                sendResult ([message attributeStringValueForName:@"id"],currentTime);
            }
            
        }
	}
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:_password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	DDLogVerbose(@"recv iq:%@",[iq description]);
//    NSError *autoriedError = nil;
//    if ([[[iq elementForName:@"error"]attributeStringValueForName:@"code"]intValue]==401) {
//        [[self xmppStream] authenticateWithPassword:@"admin" error:&autoriedError];
//    }
//    if (autoriedError) {
//        DDLogVerbose(@"author error:%@",[autoriedError description]);
//    }
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
    //回执判断
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //组装消息回执
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [self.xmppStream sendElement:msg];
        }
    }else
    {
        NSXMLElement *received = [message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
            {
                //发送成功
                if ([_actions objectForKey:@"didSendMessageSuccess"]) {
                    ZYXMPPClientDidSendMessageSuccessAction didSendSuccess = [_actions objectForKey:@"didSendMessageSuccess"];
                    didSendSuccess([message attributeStringValueForName:@"id"]);
                }
            }
        }
    }
    //聊天消息
    if ([message isChatMessageWithBody])
    {
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [[message elementForName:@"send_user"]stringValue];
        NSString *addTime = [[message elementForName:@"add_time"]stringValue];
        NSString *audioTime = [[message elementForName:@"audio_time"]stringValue];
        NSString *messageType = [[message elementForName:@"message_type"]stringValue];
        NSString *sendUserId = [[message elementForName:@"send_user_id"]stringValue];
        NSString *messageId = [message attributeStringValueForName:@"id"];
        
        if ([_actions objectForKey:@"recieveMessageSuccess"]) {
            
            ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:@"recieveMessageSuccess"];
            ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
            newMessage.user = displayName;
            newMessage.content = body;
            newMessage.addTime = addTime;
            newMessage.audioTime = audioTime;
            newMessage.messageType = messageType;
            newMessage.userId = sendUserId;
            newMessage.sendStatus = @"1";
            newMessage.messageId = messageId;
            newMessage.conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:newMessage.userId withMyUserId:originJId];
            newMessage.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:newMessage];
            recieveAction (newMessage);
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    NSXMLElement *x = [presence elementForName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    for (NSXMLElement *status in [x elementsForName:@"status"])
    {
        switch ([status attributeIntValueForName:@"code"])
        {
            case 201:
            {
                DDLogVerbose(@"enter room faild!");
            }
                break;
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    if (error) {
        DDLogVerbose(@" DisConnect error :%@",error.description);
    }

	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}
//================资源冲突=================
//- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
//{
//    
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
    [xmppStream setMyJID:[XMPPJID jidWithString:_jId]];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		xmppStream.enableBackgroundingOnSocket = needBackgroundRecieve;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
    //消息回执
//    xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = YES;
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = YES;
    

    //聊天室
    xmppRoomStorage = [[XMPPRoomCoreDataStorage alloc]init];
    XMPPMUC *xmppMuc = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [xmppMuc addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
	// Activate xmpp modules    
	[xmppReconnect         activate:xmppStream];
    [xmppMessageDeliveryRecipts activate:xmppStream];
    [xmppMuc activate:xmppStream];

	// Add ourself as a delegate to anything we may be interested in
	[xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];

	
    if (shouldUseCustomHost) {
        [xmppStream setHostName:_serverHost];
    }
//    [xmppStream setHostPort:5222];
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
//	[xmppRoster removeDelegate:self];
    [xmppRoom   removeDelegate:self];
	
	[xmppReconnect         deactivate];
//	[xmppRoster            deactivate];
//	[xmppvCardTempModule   deactivate];
//	[xmppvCardAvatarModule deactivate];
//	[xmppCapabilities      deactivate];
    [xmppMessageDeliveryRecipts deactivate];
    [xmppRoom deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppMessageDeliveryRecipts=nil;
    xmppRoomStorage = nil;
    xmppRoom = nil;
//    xmppRoster = nil;
//	xmppRosterStorage = nil;
//	xmppvCardStorage = nil;
//    xmppvCardTempModule = nil;
//	xmppvCardAvatarModule = nil;
//	xmppCapabilities = nil;
//	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = _jId;
	NSString *myPassword = _password;
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	_password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		
        if ([_actions objectForKey:@"connectServerError"]) {
            
            ZYXMPPClientConnectServerErrorAction errorAction = [_actions objectForKey:@"connectServerError"];
            
            errorAction (@"connect to server error happend!");
        }
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


//================================ turnsocket 文件传输  ===================
- (void)sendFileWithData:(NSData *)fileData withFileName:(NSString *)fileName toJID:(NSString *)jID
{
    if (!isXmppConnected) {
        DDLogVerbose(@"turnsocket connect need login");
        return;
    }

    if(needAutoHostForJID){
        jID = [NSString stringWithFormat:@"%@@%@/spark",jID,_serverHost];
    }
    XMPPJID *toUser = [XMPPJID jidWithString:jID];
    
    if (fileData) {
        fileData=nil;
    }
    fileData = [[NSMutableData alloc]initWithData:fileData];
    [TURNSocket setProxyCandidates:[NSArray arrayWithObject:_serverHost]];
    TURNSocket *fileTurn = [[TURNSocket alloc]initWithStream:self.xmppStream toJID:toUser];
    
    [fileTurn startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark - turnsocket delegate
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"turn socket connected now !!!!++++++++++++++++++!!!!!!!!!");
    
    //写入文件流
    [socket writeData:fileDataWillTrans withTimeout:240.f tag:1234567];
}
- (void)turnSocketDidFail:(TURNSocket *)sender
{
    DDLogVerbose(@"turn socket connected faild !!!++++++++++++++++!!!!!!");
}

//=============================  聊天室 ====================================//

//==========群聊
- (void)setDidRecievedGroupMessageAction:(ZYXMPPClientDidRecievedGroupChatMessage)successAction
{
    [_actions setObject:successAction forKey:@"didRecieveGroupMessageSuccess"];
}
- (void)setCreateRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"CreateRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)createRoomSuccessAction
{
    return [_actions objectForKey:@"CreateRoomSuccessAction"];
}
- (void)setJoinRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"JoinRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)joinRoomSuccessAction
{
    return [_actions objectForKey:@"JoinRoomSuccessAction"];
}
- (void)setLeaveRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"LeaveRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)leaveRoomSuccessAction
{
    return [_actions objectForKey:@"LeaveRoomSuccessAction"];
}
- (void)setDestroyRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"DestroyRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)destroyRoomSuccessAction
{
   return [_actions objectForKey:@"DestroyRoomSuccessAction"];
}

#pragma mark - room chat
- (NSString *)genrateRoomID
{
    NSString *trueJID = [NSString stringWithFormat:@"%@_grouproom",originJId];
    return trueJID;
}
- (void)initDefaultRoomConfig
{
    myRoomConfig = [[ZYXMPPRoomConfig alloc]init];
    myRoomConfig.name = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.description = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.subject = @"创建新聊天室";
    myRoomConfig.needPasswordProtect = NO;
    myRoomConfig.secret = @"";
    myRoomConfig.maxUserCount = 30;
    myRoomConfig.maxHistoryMessageReturnCount = 100;
    myRoomConfig.owner = _jId;
    myRoomConfig.admins = [NSArray array];
    myRoomConfig.enableLogging = YES;
    myRoomConfig.allowInivite = YES;
    myRoomConfig.allowPrivateMsg = NO;
    myRoomConfig.whoCanDiscoveryOthersJID = ZYXMPPRoomRoleMember;
    myRoomConfig.whoCanBroadCastMsg = ZYXMPPRoomRoleMember;
    myRoomConfig.whoCanGetRoomMemberList = ZYXMPPRoomRoleMember;
    myRoomConfig.needPersistThisRoom = YES;
    myRoomConfig.isThisPublicRoom = YES;
    myRoomConfig.isRoomForAdminOnly = NO;
    myRoomConfig.isRoomForMemberOnly = NO;
    myRoomConfig.reconfigState = YES;

    DDLogVerbose(@"init my default room config success!");
}
//创建默认聊天室
- (void)createDefaultConfigRoomUseMyJID
{
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:myRoomConfig.roomID withHostName:_serverHost];
    myRoomConfig.roomID = roomJID;
    xmppRoom  = [[XMPPRoom alloc]initWithRoomStorage:xmppRoomStorage jid:[XMPPJID jidWithString:roomJID]];
    BOOL activeNewRoomResult = [xmppRoom activate:xmppStream];
    if (activeNewRoomResult) {
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
                
        //自己加入
        [xmppRoom joinRoomUsingNickname:myRoomConfig.myNickName history:nil];
        
        //持久化
        [_innerConfigDict setObject:myRoomConfig forKey:myRoomConfig.roomID];
        [[ZYXMPPLocalPersist sharePersist]saveNewLocalRoomWithConfigure:myRoomConfig];
    }
}
- (void)createGroupChatRoomWithRoomConfig:(ZYXMPPRoomConfig *)roomConfig
{
    NSMutableDictionary *newRoomDict = [NSMutableDictionary dictionary];
    XMPPRoomCoreDataStorage *newRoomStorge = [[XMPPRoomCoreDataStorage alloc]init];
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:roomConfig.roomID withHostName:_serverHost];
    roomConfig.roomID = roomJID;
    XMPPRoom *newRoom = [[XMPPRoom alloc]initWithRoomStorage:newRoomStorge jid:[XMPPJID jidWithString:roomJID]];
    [newRoom configureRoomUsingOptions:nil];//默认没有配置，随后服务器会发送填写配置的表单过来
    BOOL activeNewRoomResult = [newRoom activate:self.xmppStream];
    if (activeNewRoomResult) {
        DDLogVerbose(@"active room success:%@ ",newRoom.description);
        [newRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //自己加入
        [newRoom joinRoomUsingNickname:roomConfig.myNickName history:nil];
        
        //保存聊天室信息
        [newRoomDict setObject:newRoom forKey:kZYXMPPRoom];
        [newRoomDict setObject:newRoomStorge forKey:kZYXMPPRoomStorge];
        [xmppRooms setObject:newRoomDict forKey:roomJID];
        
        //持久化
        [[ZYXMPPLocalPersist sharePersist]saveNewLocalRoomWithConfigure:roomConfig];
    }    
}
- (void)createDefaultConfigGroupChatRoomSpecialWithRoomName:(NSString *)roomName
{
    ZYXMPPRoomConfig *newConfig = [myRoomConfig copy];
    newConfig.name = roomName;
    newConfig.reconfigState = YES;
    
    [self createGroupChatRoomWithRoomConfig:newConfig];
    
}
//加入目标聊天室
- (void)joinGroupChatRoomWithRoomId:(NSString *)roomID withNickName:(NSString *)nickName
{
    [self enterRoom:roomID];
//    NSMutableDictionary *newRoomDict = [NSMutableDictionary dictionary];
//    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:roomID withHostName:_serverHost];
//    xmppRoom = [[XMPPRoom alloc]initWithRoomStorage:xmppRoomStorage jid:[XMPPJID jidWithString:roomJID]];
//    
//    BOOL activeNewRoomResult = [xmppRoom activate:self.xmppStream];
//    if (activeNewRoomResult) {
//        DDLogVerbose(@"active room success:%@ ",xmppRoom.description);
//        [xmppRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
//        
//        //自己加入
//        [xmppRoom joinRoomUsingNickname:nickName history:nil];
//        
//        //保存聊天室信息
//        [xmppRooms setObject:newRoomDict forKey:roomJID];
//        
//        //持久化
//        [[ZYXMPPLocalPersist sharePersist]saveOthersRoomWithRoomID:roomID];
//    }
    
}

- (void)queryRoomNickName:(NSString*)roomID
{
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:roomID withHostName:_serverHost];
    NSString *qId = [xmppStream generateUUID];

    NSXMLElement *xlmns = [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#info"];
    NSXMLElement *node = [NSXMLElement attributeWithName:@"node" stringValue:@"x-roomuser-item"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" children:nil attributes:@[xlmns,node]];
    NSXMLElement *presence = [[XMPPIQ alloc]initWithType:@"get" elementID:qId child:query];
    [presence addAttributeWithName:@"to" stringValue:roomJID];
    [presence addAttributeWithName:@"id" stringValue:qId];
    [presence addAttributeWithName:@"from" stringValue:_jId];
    [presence addAttributeWithName:@"type" stringValue:@"get"];
    [[self xmppStream] sendElement:presence];

}
- (void)enterRoom:(NSString*)roomID
{
    //query nick
    [self queryRoomNickName:roomID];
    
    //here we enter a room, or if the room does not yet exist, this method creates it
    //per XMPP documentation: "If the room does not yet exist, the service SHOULD create the room"
    //this method accepts an argument which is what you would baptize the room you wish created
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:roomID withHostName:_serverHost];
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    NSString *qId = [xmppStream generateUUID];
    [presence addAttributeWithName:@"to" stringValue:roomJID];
    [presence addAttributeWithName:@"id" stringValue:qId];
    [presence addAttributeWithName:@"from" stringValue:_jId];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    [presence addChild:x];
    [[self xmppStream] sendElement:presence];
    
}

//退出目标聊天室
- (void)quitFromRoom:(NSString *)roomID
{
    //看看当前有没有登陆这个群
    [xmppRooms enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *roomDict = (NSDictionary*)obj;
        XMPPRoom *existRoom = [roomDict objectForKey:kZYXMPPRoom];
        NSString *roomJID = [existRoom.roomJID full];
        if ([roomJID isEqualToString:roomJID]) {            
            //退群
            [existRoom leaveRoom];
            [[ZYXMPPLocalPersist sharePersist]deleteRoomInfoWithRoomID:roomJID];
            //再向远程发送一个群删除信息
            *stop = YES;
        }
    }];
}
- (void)destoryRoomWithRoomID:(NSString *)roomID
{
    //看看当前有没有登陆这个群
    [xmppRooms enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *roomDict = (NSDictionary*)obj;
        XMPPRoom *existRoom = [roomDict objectForKey:kZYXMPPRoom];
        NSString *roomJID = [existRoom.roomJID full];
        if ([roomJID isEqualToString:roomJID]) {
            //退群
            [existRoom destroyRoom];
            [[ZYXMPPLocalPersist sharePersist]deleteRoomInfoWithRoomID:roomJID];
            //再向远程发送一个群删除信息
            *stop = YES;
        }
    }];
}

- (void)getMemberListFomRoom:(NSString *)roomID withSuccessAction:(ZYXMPPClientGetRoomMemberListResultAction)successAction
{
    //一定要登陆了的群聊天室才能看到，因为只有登陆的才会返回群成员
    [xmppRooms enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *roomDict = (NSDictionary*)obj;
        XMPPRoom *existRoom = [roomDict objectForKey:kZYXMPPRoom];
        NSString *roomJID = [existRoom.roomJID full];
        if ([roomJID isEqualToString:roomJID]) {
            
            NSArray *memebList = [[ZYXMPPLocalPersist sharePersist]getRoomAllUsersWithRoomID:roomID];
            if (successAction) {
                successAction(memebList);
            }
            *stop = YES;
        }
    }];
}

- (void)sendRoomChatMessage:(ZYXMPPMessage *)newMessage toRoomJID:(NSString *)roomJID
{
	if([newMessage.content length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:newMessage.content];
        NSXMLElement *messageType = [NSXMLElement elementWithName:@"message_type"];
        [messageType setStringValue:newMessage.messageType];
        NSXMLElement *sendUser = [NSXMLElement elementWithName:@"send_user"];
        [sendUser setStringValue:newMessage.user];
        NSXMLElement *sendUserId = [NSXMLElement elementWithName:@"send_user_id"];
        [sendUserId setStringValue:newMessage.userId];
        NSXMLElement *addTime = [NSXMLElement elementWithName:@"add_time"];
        NSString *currentTime = [self returnCurrentDateTime];
		[addTime setStringValue:currentTime];
        if (![newMessage.content isEqualToString:@""]) {
            newMessage.audioTime = @"0";
        }
        NSXMLElement *audioTime = [NSXMLElement elementWithName:@"audio_time"];
        [audioTime setStringValue:newMessage.audioTime];
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        
        NSString *siID = [XMPPStream generateUUID];
        XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" elementID:siID];
		[message addChild:body];
        [message addChild:messageType];
        [message addChild:sendUser];
        [message addChild:sendUserId];
        [message addChild:addTime];
        [message addChild:audioTime];
        [message addChild:receipt];
        
        DDLogVerbose(@"send message once time!");
        [xmppRoom sendMessage:message];
        
	}

}

#pragma mark xmpproom delegate
//============================================ XMPPRoom Delegate =========================
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    [xmppRoom fetchConfigurationForm];
    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
    [xmppRoom fetchModeratorsList];
}

/**
 *在这里确认房间配置,才能解锁房间
 **/
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"didFetchConfigure:%@",[configForm description]);
    
    NSString *roomJID = [[sender roomJID]full];
    
    ZYXMPPRoomConfig *checkConfig = [[ZYXMPPLocalPersist sharePersist]checkIfNeedReFecthRoomConfigForRoomID:roomJID];
    if (checkConfig) {
        
        DDLogVerbose(@"check config:%@",checkConfig);
        NSXMLElement *configElement = [ZYXMPPRoomConfig configElementWithRoomConfigModel:checkConfig];
        [sender configureRoomUsingOptions:configElement];
        [_innerConfigDict removeObjectForKey:roomJID];
    }


}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"didConfigure result:%@",[iqResult description]);
    
    [sender inviteUser:[XMPPJID jidWithString:@"31@112.124.37.183"] withMessage:@"加入我的群吧"];
    [sender inviteUser:[XMPPJID jidWithString:@"37@112.124.37.183"] withMessage:@"加入我的群吧"];

    if ([self createRoomSuccessAction]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZYXMPPClientRoomExcuteResultAction resultAction = [self createRoomSuccessAction];
            NSString *roomID = [sender.roomJID full];
            NSString *getSubjectName = [[ZYXMPPLocalPersist sharePersist]getRoomSubjectByRoomID:roomID];
            NSString *resultMsg = [NSString stringWithFormat:@"创建群:%@成功",getSubjectName];
            resultAction(YES,resultMsg);
            
            //更新room配置状态
            NSString *roomJID = [[sender roomJID]full];
            [[ZYXMPPLocalPersist sharePersist]updateRoomReconfigState:NO forRoom:roomJID];
            
        });
    }
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

/**
 * Invoked when a message is received.
 * The occupant parameter may be nil if the message came directly from the room, or from a non-occupant.
 **/
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"group message :%@",message);
    
    //聊天消息
    if ([[message attributeStringValueForName:@"type"]isEqualToString:@"groupchat"])
    {
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [[message elementForName:@"send_user"]stringValue];
        NSString *addTime = [[message elementForName:@"add_time"]stringValue];
        NSString *audioTime = [[message elementForName:@"audio_time"]stringValue];
        NSString *messageType = [[message elementForName:@"message_type"]stringValue];
        NSString *sendUserId = [[message elementForName:@"send_user_id"]stringValue];
        
        if ([_actions objectForKey:@"didRecieveGroupMessageSuccess"]) {
            
            ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:@"didRecieveGroupMessageSuccess"];
            ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
            newMessage.user = displayName;
            newMessage.content = body;
            newMessage.addTime = addTime;
            newMessage.audioTime = audioTime;
            newMessage.messageType = messageType;
            newMessage.userId = sendUserId;
            newMessage.sendStatus = @"1";
            
            DDLogVerbose(@"new group messsage:%@",newMessage);
            recieveAction (newMessage);
        }
    }
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    //保存群成员信息
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
//================ MUC Delegate ================
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message
{
        XMPPRoom *newRoom = [[XMPPRoom alloc]initWithRoomStorage:nil jid:roomJID];
        [newRoom activate:xmppStream];
        [newRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [newRoom joinRoomUsingNickname:myRoomConfig.myNickName history:nil];

}
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message
{
    
}


@end
