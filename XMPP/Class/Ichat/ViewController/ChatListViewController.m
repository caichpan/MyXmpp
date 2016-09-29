//
//  ChatListViewController.m
//  XMPP
//
//  Created by CCP on 16/9/23.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "ChatListViewController.h"

@interface ChatListViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    self.loadingView.backgroundColor =[UIColor clearColor];
    self.indicatorView.backgroundColor = [UIColor clearColor];
    
    // 监听一个登录状态的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxx:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:ChatListStatusChangeNotification object:nil];

}
-(void)loginStatusChange:(NSNotification *)noti{
    
    //通知是在子线程被调用，刷新UI在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",noti.userInfo);
        // 获取登录状态
        int status = [noti.userInfo[@"loginStatus"] intValue];
        
        switch (status) {
            case XMPPResultTypeConnecting://正在连接
                [self.indicatorView startAnimating];
                break;
            case XMPPResultTypeNetErr://连接失败
                [ProgressHUD showMessageError:@"链接失败"];
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginSuccess://登录成功也就是连接成功
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginFailure://登录失败
                [ProgressHUD showMessageError:@"登陆失败"];
                [self.indicatorView stopAnimating];
                break;
            default:
                break;
        }
    });
    
    
}

@end
