//
//  RegisterViewController.h
//  XMPP
//
//  Created by ccp on 16/9/19.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "ViewController.h"

@protocol WCRegisgerViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)regisgerViewControllerDidFinishRegister;

@end
@interface RegisterViewController : ViewController
@property (nonatomic, weak) id<WCRegisgerViewControllerDelegate> delegate;
@end
