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

@implementation ZYXMPPClient
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

#pragma mark - init 
- (id)init
{
    if (self = [super init]) {
        
        _actions = [[NSMutableDictionary alloc]init];
        
        
    }
    return self;
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
    
    _jId = jidString;
    if (needAutoHostForJID) {
        _jId = [NSString stringWithFormat:@"%@@%@",_jId,_serverHost];
    }
    _password = password;
    
    // Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Setup the XMPP stream
    if (isXmppConnected) {
        return;
    }
    
	[self setupStream];
    
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
- (void)setJabbredServerAddress:(NSString *)address
{
    _serverHost = address;
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Send  Message  and Recieve Message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//返回当前时间
- (NSString*)returnCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateTime = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateTime;
}
- (void)sendMessageToUser:(ZYXMPPUser *)toUser withContent:(ZYXMPPMessage *)newMessage
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
		[addTime setStringValue:[self returnCurrentDateTime]];
        if (![newMessage.content isEqualToString:@""]) {
            newMessage.audioTime = @"0";
        }
        NSXMLElement *audioTime = [NSXMLElement elementWithName:@"audio_time"];
        [audioTime setStringValue:newMessage.audioTime];
        
		NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
		[message addAttributeWithName:@"type" stringValue:@"chat"];
		[message addAttributeWithName:@"to" stringValue:toUser.jID];
		[message addChild:body];
        [message addChild:messageType];
        [message addChild:sendUser];
        [message addChild:sendUserId];
        [message addChild:addTime];
        [message addChild:audioTime];

		
		[xmppStream sendElement:message];
    
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
	
    DDLogVerbose(@"will login password:%@",_password);
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
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody])
	{
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [[message elementForName:@"send_user"]stringValue];
        NSString *addTime = [[message elementForName:@"add_time"]stringValue];
        NSString *audioTime = [[message elementForName:@"audio_time"]stringValue];
        NSString *messageType = [[message elementForName:@"message_type"]stringValue];
        NSString *sendUserId = [[message elementForName:@"send_user_id"]stringValue];
        
		if ([_actions objectForKey:@"recieveMessageSuccess"]) {
            
            ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:@"recieveMessageSuccess"];
            
            ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
            newMessage.user = displayName;
            newMessage.content = body;
            newMessage.addTime = addTime;
            newMessage.audioTime = audioTime;
            newMessage.messageType = messageType;
            newMessage.userId = sendUserId;
            recieveAction (newMessage);
        }
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
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
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
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
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
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


@end
