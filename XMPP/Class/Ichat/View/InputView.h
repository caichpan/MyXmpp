//
//  InputView.h
//  XMPP
//
//  Created by CCP on 16/9/23.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
+(instancetype)inputView;
@end
