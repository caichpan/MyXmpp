//
//  MyButton.h
//  XMPP
//
//  Created by CCP on 16/9/18.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyButton;
typedef void(^XMGNButtonClickBlock)(MyButton *);
@interface MyButton : UIButton
/** 回调 */
@property (nonatomic, copy) XMGNButtonClickBlock block;

+ (instancetype)createXMGButton;
@end
