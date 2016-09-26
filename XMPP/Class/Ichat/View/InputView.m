//
//  InputView.m
//  XMPP
//
//  Created by CCP on 16/9/23.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "InputView.h"

@implementation InputView

+(instancetype)inputView{
    return [[[NSBundle mainBundle]loadNibNamed:@"InputView" owner:nil options:nil] lastObject];
}

@end
