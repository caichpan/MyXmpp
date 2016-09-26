//
//  ProgressHUD.h
//  HuanXin
//
//  Created by CCP on 16/9/1.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface ProgressHUD : NSObject
+(void)showLoadingWithMessage:(NSString *)message;//显示转圈
+(void)dismess;//取消转圈
+(void)showMessage:(NSString *)message;//显示弹出提示信息，时间可设置
+(void)showMessageSuccess:(NSString *)message;//成功
+(void)showMessageError:(NSString *)message;//失败

/*
 * 正在加载的时候弹出信息
 */
+(void)showSuccessWithLoading:(NSString *)message;
+(void)showErrorWithLoading:(NSString *)message;

/*
 * 动态
 */
+(void)showSuccessWithLoading:(NSString *)message dismessTime:(double)time;
@end
