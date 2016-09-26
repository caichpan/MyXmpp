//
//  IChatViewController.h
//  XMPP
//
//  Created by CCP on 16/9/19.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPJID.h"

@interface IChatViewController : BaseViewController
@property (nonatomic, strong) XMPPJID *friendJid;
@end
