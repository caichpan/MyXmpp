//
//  MeViewController.m
//  XMPP
//
//  Created by CCP on 16/9/21.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "MeDetailViewController.h"

@interface MeViewController ()<MeDetailViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;
@end

@implementation MeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    
    // 显示当前用户个人信息
    
    // 如何使用CoreData获取数据
    // 1.上下文【关联到数据】
    
    // 2.FetchRequest
    
    // 3.设置过滤和排序
    
    // 4.执行请求获取数据
    
    //xmpp提供了一个方法，直接获取个人信息
    [self refreshUserData];
    
}

-(void)refreshUserData{
    XMPPvCardTemp *myVCard =[XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headerView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nickNameLabel.text = @"用户名(null)";
    if (myVCard.nickname) {
        self.nickNameLabel.text = myVCard.nickname;
    }
    
    // 设置微信号[用户名]
    NSLog(@"%@",myVCard.jid.user);
    
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];


}

- (IBAction)logout:(id)sender {
    [[XMPPTool sharedXMPPTool] logout];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[MeDetailViewController class]]) {
        MeDetailViewController *editVc = destVc;
      
        editVc.delegate = self;
    }
}
@end
