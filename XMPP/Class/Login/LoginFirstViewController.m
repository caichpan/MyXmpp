//
//  LoginFirstViewController.m
//  XMPP
//
//  Created by CCP on 16/9/19.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "LoginFirstViewController.h"
#import "RegisterViewController.h"
#import "MyNavigationController.h"

@interface LoginFirstViewController ()<WCRegisgerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    // 设置TextField和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    // 设置用户名为上次登录的用户名
    
    //从沙盒获取用户名
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.userLabel.text = user;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
}


- (IBAction)loginBtnClick:(id)sender {
    
    // 保存数据到单例
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    // 调用父类的登录
    [super login];
}

- (IBAction)registerClick:(id)sender {
     [self performSegueWithIdentifier:@"registerid" sender:@[@"registerid"]];
    
}
- (IBAction)otherLogin:(id)sender {
    [self performSegueWithIdentifier:@"loginid" sender:@[@"loginid"]];
}


- (IBAction)forgetPsd:(id)sender {
    [ProgressHUD showMessageError:@"操，忘记你妹!"];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 获取注册控制器
    id destVc = segue.destinationViewController;

      if ([sender[0] isEqual:@"registerid"]) {
          MyNavigationController *nav = destVc;
          //获取根控制器
          RegisterViewController *registerVc =  (RegisterViewController *)nav.topViewController;
          // 设置注册控制器的代理
          registerVc.delegate = self;
      }
    
}

#pragma mark regisgerViewController的代理
-(void)regisgerViewControllerDidFinishRegister{
    NSLog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    
    // 提示
      [ProgressHUD showSuccessWithLoading:@"注册成功请登录"];
    
}
@end
