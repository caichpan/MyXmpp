//
//  MeEditProfileViewController.m
//  XMPP
//
//  Created by CCP on 16/9/22.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "MeEditProfileViewController.h"

@interface MeEditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MeEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置标题和TextField的默认值
    self.title = self.cell.textLabel.text;
    
    if ([self.cell.textLabel.text isEqualToString:@"我的二维码"]) {
//        UIView *view = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//        UIImageView *imv = [[UIImageView alloc]init ];//WithFrame:<#(CGRect)#>;
//        imv.image = [UIImage imageNamed:@"erweima"];
//        imv.center = self.view.center;
//        [view addSubview:imv];
//        [self.tableView addSubview:view];

        return;
    }
        
        
    self.textField.text = self.cell.detailTextLabel.text;
    // 右边添加个按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];

  }

-(void)saveBtnClick{

    
    // 1.更改Cell的detailTextLabel的text
    self.cell.detailTextLabel.text = self.textField.text;
    
    [self.cell layoutSubviews ];
    
    // 2.当前的控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    // 调用代理
    if([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSave)]){
        // 通知代理，点击保存按钮
        [self.delegate editProfileViewControllerDidSave];
    }
    
    
}
@end
