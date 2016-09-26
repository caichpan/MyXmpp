//
//  MeDetailViewController.m
//  XMPP
//
//  Created by CCP on 16/9/21.
//  Copyright © 2016年 CCP. All rights reserved.

#import "MeDetailViewController.h"
#import "MeEditProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface MeDetailViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,WCEditProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *haedView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号


@property (weak, nonatomic) IBOutlet UILabel *myadgress;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *arear;
@property (weak, nonatomic) IBOutlet UILabel *dis;

@end

@implementation MeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    [self loadVCard];
}
/**
 *  加载电子名片信息
 */
-(void)loadVCard{
    //显示人个信息
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.haedView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    if (myVCard.nickname) {
         self.nicknameLabel.text = myVCard.nickname;
    }
  
    // 设置微信号[用户名]
    self.weixinNumLabel.text = [WCUserInfo sharedWCUserInfo].user;

    
  /**************************************************/
    if (myVCard.formattedName) {
        self.myadgress.text =myVCard.formattedName;
    }
    
    if (myVCard.familyName) {
        self.sex.text =myVCard.familyName;
    }
    
    if (myVCard.givenName) {
        self.arear.text =myVCard.givenName;
    }
    
    if (myVCard.prefix) {
        self.dis.text =myVCard.prefix;
    }

    
    // 公司
  //  self.orgnameLabel.text = myVCard.orgName;
    
    // 部门
    if (myVCard.orgUnits.count > 0) {
      //  self.orgunitLabel.text = myVCard.orgUnits[0];
        
    }
    
    //职位
 //   self.titleLabel.text = myVCard.title;
    
    //电话
//warning myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    
    
    
    // 使用note字段充当电话
 //   self.phoneLabel.text = myVCard.note;
    
    //邮件
    // 用mailer充当邮件
 //   self.emailLabel.text = myVCard.mailer;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取cell.tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    // 判断
    if (tag == 10) {//不做任务操作
        NSLog(@"不做任务操作");
        return;
    }
    
    if(tag == 0){//选择照片
        NSLog(@"选择照片");
        UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [as showInView:self.view];
        
    }else{
        NSLog(@"跳到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];

    }
    
}

#pragma mark actionsheet的代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex == 2){//取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 设置代理
    imagePicker.delegate =self;
    
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {//照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{//相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    // 获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.haedView.image = image;
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 更新到服务器
    [self editProfileViewControllerDidSave];
    
}

#pragma mark 编辑个人信息的控制器代理
-(void)editProfileViewControllerDidSave{
    // 保存
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    // 图片
    myvCard.photo = UIImagePNGRepresentation(self.haedView.image);
    
    // 昵称
    myvCard.nickname = self.nicknameLabel.text;
    NSLog(@"%@",myvCard.nickname);
    
    myvCard.formattedName = self.myadgress.text;
    myvCard.familyName = self.sex.text;
    myvCard.givenName = self.arear.text;
    myvCard.prefix = self.dis.text;
    
    
    // 公司
 //   myvCard.orgName = self.orgnameLabel.text;
    
    // 部门
//    if (self.orgunitLabel.text.length > 0) {
//        myvCard.orgUnits = @[self.orgunitLabel.text];
//    }
    
    
    // 职位
  //  myvCard.title = self.titleLabel.text;
    
    
    // 电话
 //   myvCard.note =  self.phoneLabel.text;
    
    // 邮件
  //  myvCard.mailer = self.emailLabel.text;
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[XMPPTool sharedXMPPTool].vCard updateMyvCardTemp:myvCard];
    
    if (self.delegate) {
        [self.delegate refreshUserData];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[MeEditProfileViewController class]]) {
        MeEditProfileViewController *editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

@end
