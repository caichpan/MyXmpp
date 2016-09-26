//
//  XMPPTipView.h
//  WWW
//
//  Created by ccp on 16/9/24.
//  Copyright © 2016年 eee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMPPTipView : UIView
+(XMPPTipView *)creatViewWithTitle:(NSString *)message succ:(void (^)(BOOL isYes))succ;
@end
