//
//  MyButton.m
//  XMPP
//
//  Created by CCP on 16/9/18.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(MyButton *)btn
{
    if (_block) {
        _block(btn);
    }
}

+ (instancetype)createXMGButton
{
    return [MyButton buttonWithType:UIButtonTypeCustom];
}

@end
