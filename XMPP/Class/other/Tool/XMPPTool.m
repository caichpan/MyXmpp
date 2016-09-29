//
//  XMPPTool.m
//  XMPP
//
//  Created by CCP on 16/9/20.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "XMPPTool.h"
#import "XMPPTipView.h"

NSString *const ChatListStatusChangeNotification = @"ChatListStatusChangeNotification";

/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */
@interface XMPPTool ()<XMPPStreamDelegate>{

    XMPPResultBlock _resultBlock;
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    
     XMPPReconnect *_reconnect;// 自动连接模块
    
    XMPPvCardAvatarModule *_avatar;//头像模块
    
    XMPPMessageArchiving *_msgArchiving;//聊天模块
    
}

// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;


// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;
@end


@implementation XMPPTool
singleton_implementation(XMPPTool)

#pragma mark  -私有方法
#pragma mark 初始化XMPPStream，1
-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    // 添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];

    
    // 添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    
    //ios7以下要想在后台运行，除了添加plist还要加这句话，而且要在真机，模拟器是模拟不了的
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}


#pragma mark 释放xmppStream相关的资源
-(void)teardownXmpp{
    
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    
}

#pragma mark 连接到服务器，2
-(void)connectToHost{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    
    // 发送通知【正在连接】
    [self postNotification:XMPPResultTypeConnecting];

    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    
    // 从单例获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    }else{
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"teacher.local" resource:@"iphone" ];
    _xmppStream.myJID = myJID;
    
    
    NSString *hosgName = @"";
    // 设置服务器域名192.168.0.108   teacher.local
    
    #if (TARGET_IPHONE_SIMULATOR)
        
        hosgName = @"teacher.local";
        
    #else
        
       hosgName = @"192.168.0.107";
        
    #endif
    
    _xmppStream.hostName = hosgName;//不仅可以是域名，还可是IP地址
    
    
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        NSLog(@"%@",err);
    }
}


#pragma mark 连接到服务成功后，再发送密码授权，3
-(void)sendPwdToHost{
    NSLog(@"再发送密码授权");
    NSError *err = nil;
    
    // 从单例里获取密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark  授权成功后，发送"在线" 消息，4
-(void)sendOnlineToHost{
    
    NSLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
}

/**
 * 通知 WCHistoryViewControllers 登录状态
 *
 */
-(void)postNotification:(XMPPResultType)resultType{
    
    // 将登录状态放入字典，然后通过通知传递
    NSDictionary *userInfo = @{@"loginStatus":@(resultType)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatListStatusChangeNotification object:nil userInfo:userInfo];
}


#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
        [_xmppStream  registerWithElements:@[@"'123"] error:nil];
    }else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
    
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }
    
    if (error) {
        //通知 【网络不稳定】
        [self postNotification:XMPPResultTypeNetErr];
    }

    NSLog(@"与主机断开连接 %@",error);
    
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    
    [self sendOnlineToHost];
    // 回调控制器登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    [self postNotification:XMPPResultTypeLoginSuccess];
}

#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    // 判断block有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    
     [self postNotification:XMPPResultTypeLoginFailure];
}
//   AppDelegate *app = [UIApplication sharedApplication].delegate;
//   [app logout];


#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    NSLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
    
}

#pragma mark 接收到好友消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"%@",message);
    
    //如果当前程序不在前台，发出一个本地通知
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        NSLog(@"在后台");
        
        //本地通知
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        
        // 设置内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
        
        // 设置通知执行时间
        localNoti.fireDate = [NSDate date];
        
        //声音
        localNoti.soundName = @"default";
        
        //执行
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        
        //{"aps":{'alert':"zhangsan\n have dinner":'sound':'default',badge:'12'}}
    }
}


//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
//    
//    
//    return YES;
//}
//- (XMPPIQ *)xmppStream:(XMPPStream *)sender willReceiveIQ:(XMPPIQ *)iq{
//    NSLog(@"wef");
//    
//    return iq;
//}

#pragma mark 收到好友请求回调，以及好友注销下线，上线回调
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence;{
    
    //presence.from 消息是谁发送过来
    
    
    if ([[presence type] isEqualToString:@"subscribe"])//收到好友请求
    {
        NSLog(@"收到好友请求");
        //取得好友状态
    //    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
        //请求的用户
        NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];

        
        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
        NSLog(@"%@",jid.domain);
        
        NSString *jidStr = [NSString stringWithFormat:@"%@@%@",jid.domain,domain];
        XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
        
        //你发送好友请求后，对方同意了你的好友请求也会回调这里，所以这里处理下如果是对方同意你请求情况就不弹出添加好友请求提示狂了
        if ([[NSUserDefaults standardUserDefaults]objectForKey:jid.domain]) {
            NSString *domain = [[NSUserDefaults standardUserDefaults]objectForKey:jid.domain];
            if ([domain isEqualToString:jid.domain]) {
                
                NSLog(@"对方已经同意了你的好友请求");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:jid.domain];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //接收添加好友请求
            XMPPTipView *view = [XMPPTipView creatViewWithTitle:[NSString stringWithFormat:@"%@想要加你为好友",jid.domain] succ:^(BOOL isYes) {
                if (isYes) {//同意
                    [self.roster acceptPresenceSubscriptionRequestFrom:friendJid andAddToRoster:YES];
                }else{//拒绝
                    [self.roster rejectPresenceSubscriptionRequestFrom:friendJid];
                    [[XMPPTool sharedXMPPTool].roster removeUser:friendJid];//拒绝了最后把它删了，以免后患
                }
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:view];

        });
        
        
       // 同意好友请求 [self.roster acceptPresenceSubscriptionRequestFrom:friendJid andAddToRoster:YES];
        
        //拒绝好友请求
        //[self.roster rejectPresenceSubscriptionRequestFrom:friendJid];
    }
    
    if ([[presence type] isEqualToString:@"unsubscribed"])//对方拒绝了你的请求
    {
        NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
        
        
        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
        NSLog(@"%@",jid.domain);
        
        NSString *jidStr = [NSString stringWithFormat:@"%@@%@",jid.domain,domain];
        XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
        [[XMPPTool sharedXMPPTool].roster removeUser:friendJid];
        
         dispatch_async(dispatch_get_main_queue(), ^{
             [ProgressHUD showMessageError:@"对方拒绝了你的请求"];
            });
        
        NSLog(@"对方拒绝了你的请求");
    }
    
}

#pragma mark -公共方法
-(void)logout{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    // 3. 回到登录界面
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //    self.window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4.更新用户的登录状态
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
}

-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    // 先把block存起来
    _resultBlock = resultBlock;
    
    //    Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    //    if (!_xmppStream.isConnected) {
    //         [_xmppStream disconnect];
    //    }
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送密码
    [self connectToHost];
}

-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

-(void)dealloc{
    [self teardownXmpp];
}
@end
