//
//  ViewController.m
//  XMPP
//  Created by CCP on 16/9/18.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)login{
    /*
     * 官方的登录实现
     
     * 1.把用户名和密码放在WCUserInfo的单例
     
     
     * 2.调用 AppDelegate的一个login 连接服务并登录
     */
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    });
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    // 登录之前给个提示
    
    [ProgressHUD showLoadingWithMessage:@"登录中..."];

    [XMPPTool sharedXMPPTool].registerOperation = NO;
    
    __weak typeof(self) selfVc = self;
    
    [[XMPPTool sharedXMPPTool] xmppUserLogin:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}


-(void)handleResultType:(XMPPResultType)type{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                [ProgressHUD showMessageError:@"用户名或者密码不正确"];
                break;
            case XMPPResultTypeNetErr:
                [ProgressHUD showMessageError:@"网络不给力"];
            default:
                break;
        }
    });
    
}


-(void)enterMainPage{
    
    // 更改用户的登录状态为YES
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    // 把用户登录成功的数据，保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 登录成功来到主界面
    // 此方法是在子线程补调用，所以在主线程刷新UI
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
    
     [UIStoryboard showInitialVCWithName:@"Main"];
}



@end
