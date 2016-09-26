//
//  MeDetailViewController.h
//  XMPP
//
//  Created by CCP on 16/9/21.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeDetailViewDelegate <NSObject>

-(void)refreshUserData;

@end

@interface MeDetailViewController : UITableViewController
@property (nonatomic , weak)id <MeDetailViewDelegate>delegate;
@end
