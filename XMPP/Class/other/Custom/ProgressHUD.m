//
//  ProgressHUD.m
//  HuanXin
//
//  Created by CCP on 16/9/1.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "ProgressHUD.h"


@implementation ProgressHUD
+(void)showLoadingWithMessage:(NSString *)message{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

}

+(void)dismess{
    [SVProgressHUD dismiss];
}

+(void)showMessage:(NSString *)message{

  //  [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:message];
}

+(void)showMessageSuccess:(NSString *)message{
    
        [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:message];
}

+(void)showMessageError:(NSString *)message{
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showInfoWithStatus:message];

}

+(void)showSuccessWithLoading:(NSString *)message{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:message];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [SVProgressHUD dismiss];
    });
}

+(void)showErrorWithLoading:(NSString *)message{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showInfoWithStatus:message];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [SVProgressHUD dismiss];
    });
}

+(void)showSuccessWithLoading:(NSString *)message dismessTime:(double)time{
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:message];
    
    double delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [SVProgressHUD dismiss];
    });

}

//+ (SVProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    // 快速显示一个提示信息
//    SVProgressHUD *hud = [SVProgressHUD showsta];
//    hud.labelText = message;
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
//    return hud;
//}
@end



