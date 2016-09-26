//
//  MeEditProfileViewController.h
//  XMPP
//
//  Created by CCP on 16/9/22.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate <NSObject>

-(void)editProfileViewControllerDidSave;


@end
@interface MeEditProfileViewController : UITableViewController
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, weak) id<WCEditProfileViewControllerDelegate> delegate;
@end
