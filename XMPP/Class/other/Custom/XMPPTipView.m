//
//  XMPPTipView.m
//  WWW
//
//  Created by ccp on 16/9/24.
//  Copyright © 2016年 eee. All rights reserved.
//

#import "XMPPTipView.h"
#import "MyButton.h"

@implementation XMPPTipView


+(XMPPTipView *)creatViewWithTitle:(NSString *)message succ:(void (^)(BOOL isYes))succ{
    XMPPTipView *view = [[XMPPTipView alloc]init];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    view.backgroundColor = [UIColor yellowColor];
    view.frame = CGRectMake((window.frame.size.width - 150)/2, 200, 150, 100);

    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    title.text = message;
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];

    MyButton *dismess = [[MyButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(title.frame)+10, 60, 30)];
    [dismess setTitle:@"不同意" forState:UIControlStateNormal];
    dismess.backgroundColor = [UIColor grayColor];
    dismess.block = ^(MyButton *button){
        if (succ) {
            succ(NO);
        }
         [view removeFromSuperview];
    };
    [view addSubview:dismess];

    
    
    MyButton *commen = [[MyButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dismess.frame)+10,dismess.frame.origin.y,60,30)];
    [commen setTitle:@"同意" forState:UIControlStateNormal];
    commen.backgroundColor = [UIColor grayColor];
    commen.block = ^(MyButton *button){
        
        if (succ) {
            succ(YES);
        }
        
        [view removeFromSuperview];
    };
    [view addSubview:commen];

    
    return view;
}

@end
