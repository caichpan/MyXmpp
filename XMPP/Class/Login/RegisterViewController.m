//
//  RegisterViewController.m
//  XMPP
//
//  Created by ccp on 16/9/19.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    // 判断当前设备的类型 改变左右两边约束的距离
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    // 设置TextFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (IBAction)registerBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    // 判断用户输入的是否为手机号码
    if (![self.userField isTelphoneNum]) {
        [ProgressHUD showMessageError:@"请输入正确的手机号码"];
        return;
    }
    
    // 1.把用户注册的数据保存单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    
    // 2.调用AppDelegate的xmppUserRegister
    
    [XMPPTool sharedXMPPTool].registerOperation = YES;
    
    // 提示
    [ProgressHUD showLoadingWithMessage:@"注册中....."];
    
    __weak typeof(self) selfVc = self;
    [[XMPPTool sharedXMPPTool] xmppUserRegister:^(XMPPResultType type) {
        
        [selfVc handleResultType:type];
    }];

}

/**
 *  处理注册的结果
 */
-(void)handleResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        switch (type) {
            case XMPPResultTypeNetErr:
                [ProgressHUD showErrorWithLoading:@"网络不稳定"];
                break;
            case XMPPResultTypeRegisterSuccess:
              
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
                
            case XMPPResultTypeRegisterFailure:
                [ProgressHUD showErrorWithLoading:@"注册失败,用户名重复"];
                break;
            default:
                break;
        }
    });
    
    
}



- (IBAction)cancelClick:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textChange:(id)sender {
        // 设置注册按钮的可能状态
        BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
        self.registerBtn.enabled = enabled;
}

//- (IBAction)textChange {
//    // 设置注册按钮的可能状态
//    BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
//    self.registerBtn.enabled = enabled;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
