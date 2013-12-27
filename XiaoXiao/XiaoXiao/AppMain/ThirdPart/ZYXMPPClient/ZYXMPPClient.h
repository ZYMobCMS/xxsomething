//
//  ZYXMPPClient.h
//  ZYXMPPClient
//
//  Created by ZYVincent on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

/************
 
 ***  必须将所有ZYXMPPClient 下的文件都设置ARC标示，在build phases-> compile sources 双击.m文件，填写 -fobjc-arc
 ***  添加库文件支持  coreLocation.framework,libresolv.dylib,libxml2.dylib,scurity.framework,systemConfiguration.framework
 ***  CFNetWork.framework,CoreData.framework
 ***  添加头文件路径包含 Build Settings -> search Path -> Header search paths : 添加 /usr/include/libxml2
 
 ***********/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZYXMPPUser.h"
#import "ZYXMPPMessage.h"

#import "XMPPFramework.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "XMPPMUC.h"
#import "XMPPRoom.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

//文件传输协议
#import "TURNSocket.h"

#import <CFNetwork/CFNetwork.h>

typedef void (^ZYXMPPClientStartSuccessAction) (NSString *successMsg);
typedef void (^ZYXMPPClientStartFaildAction) (NSString *faildMsg);
typedef void (^ZYXMPPClientConnectServerErrorAction) (NSString *errMsg);
typedef void (^ZYXMPPClientSendMessageFaildAction) (ZYXMPPMessage *message,ZYXMPPUser *toUser);
typedef void (^ZYXMPPClientSendMessageSuccessAction) (ZYXMPPMessage *message,ZYXMPPUser *toUser);
typedef void (^ZYXMPPClientDidRecievedMessageAction) (ZYXMPPMessage *newMessage);
typedef void (^ZYXMPPClientDidSendMessageSuccessAction) (NSString *messageId);

@interface ZYXMPPClient : NSObject<XMPPRosterDelegate,TURNSocketDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts;
    
    //聊天室
    
	NSString *_password;
    NSString *_jId;
    NSString *_serverHost;
    NSString *originJId;
    BOOL      shouldUseCustomHost;
    NSMutableDictionary *_actions;

	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    BOOL needAutoHostForJID;
    BOOL needBackgroundRecieve;
    
    BOOL isTraningFile;//是否正在传输文件
    NSMutableData *fileDataWillTrans;//将要传输的文件数据
}
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, assign, readonly) BOOL hasConfigedClient;
@property (nonatomic, assign, readonly) BOOL backgroundActiveEnbaleState;

+ (ZYXMPPClient*)shareClient;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

//是否需要用主机补全JID
- (void)setNeedAutoJIDWithCustomHostName:(BOOL)state;
- (void)startClientWithJID:(NSString *)jidString withPassword:(NSString*)password;
- (void)setStartClientSuccessAction:(ZYXMPPClientStartSuccessAction)successAction;
- (void)setStartClientFaildAction:(ZYXMPPClientStartFaildAction)faildAction;
- (void)setDidSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction;
- (void)setConnectToServerErrorAction:(ZYXMPPClientConnectServerErrorAction)errorAction;

- (void)sendMessageToUser:(ZYXMPPUser *)toUser withContent:(ZYXMPPMessage*)newMessage withSendResult:(void (^)(NSString *messageId,NSString *addTime))sendResult;
- (void)setSendMessageSuccessAction:(ZYXMPPClientSendMessageSuccessAction)successAction;
- (void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction;

- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction;

- (void)setNeedUseCustomHostAddress:(BOOL)shouldUse;
- (void)setJabbredServerAddress:(NSString*)address;
- (void)setNeedBackgroundRecieve:(BOOL)needBackground;

- (void)clientTearDown;
- (BOOL)connect;
- (void)disconnect;
//-----流传送socket5byte扩展
- (void)sendFileWithData:(NSData*)fileData withFileName:(NSString*)fileName toJID:(NSString*)jID;


@end
