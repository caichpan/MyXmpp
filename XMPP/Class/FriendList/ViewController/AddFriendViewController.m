//
//  AddFriendViewController.m
//  XMPP
//
//  Created by CCP on 16/9/22.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()<UITextFieldDelegate>

@end

@implementation AddFriendViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 添加好友
    
    // 1.获取好友账号
    NSString *user = textField.text;
    NSLog(@"%@",user);
    
    // 判断这个账号是否为手机号码
    if(![textField isTelphoneNum]){
        //提示
        [ProgressHUD showMessageError:@"请输入正确的手机号码"];
        return YES;
    }
    
    //判断是否添加自己
    if([user isEqualToString:[WCUserInfo sharedWCUserInfo].user]){
        [ProgressHUD showMessageError:@"不能添加自己为好友"];
        return YES;
    }
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:user];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //判断好友是否已经存在
    if([[XMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[XMPPTool sharedXMPPTool].xmppStream]){
        [ProgressHUD showMessageError:@"当前好友已经存在"];
        return YES;
    }
    
    
    // 2.发送好友添加的请求
    // 添加好友,xmpp有个叫订阅
    
    [[XMPPTool sharedXMPPTool].roster subscribePresenceToUser:friendJid];
    [ProgressHUD showMessageSuccess:@"好友请求已发送"];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    return YES;
}

@end
