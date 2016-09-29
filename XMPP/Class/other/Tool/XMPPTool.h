//
//  XMPPTool.h
//  XMPP
//
//  Created by CCP on 16/9/20.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"
#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

extern NSString *const ChatListStatusChangeNotification;
typedef enum {
    XMPPResultTypeConnecting,//连接中...
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

typedef void (^XMPPResultBlock)(XMPPResultType type);// XMPP请求结果的block
@interface XMPPTool : NSObject

singleton_interface(XMPPTool);

@property (nonatomic, strong,readonly)XMPPStream *xmppStream;
@property (nonatomic, strong,readonly)XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong,readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
@property (nonatomic, strong,readonly)XMPPMessageArchivingCoreDataStorage *msgStorage;//聊天的数据存储
@property (nonatomic, strong,readonly)XMPPRoster *roster;//花名册模块

/**
 *  注册标识 YES 注册 / NO 登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;//注册操作


// 注销
-(void)logout;

/**
 *  用户登录
 */
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/**
 *  用户注册
 */
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

@end
