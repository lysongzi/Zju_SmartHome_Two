//
//  DLLeftSlideMenuViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLeftSlideMenuViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JYLoginViewController.h"
#import "JYChangePwdViewController.h"
#import "CYFChangeMailViewController.h"


#import "AppDelegate.h"
#import "AllUtils.h"

#import "CYFImageStore.h"
#import "MBProgressHUD+MJ.h"

#define MAX_CENTER_X [[UIScreen mainScreen] bounds].size.width
#define LINE_COLOR [UIColor colorWithRed:0.892 green:0.623 blue:0.473 alpha:0.5]

@interface DLLeftSlideMenuViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIImageView *userPhoto;

@end


@implementation DLLeftSlideMenuViewController

-(void)viewDidLoad{
  [super viewDidLoad];
  CGRect screen = [[UIScreen mainScreen] bounds];
  float centerX = screen.size.width / 2;
  self.view.backgroundColor = [UIColor colorWithRed:0.224 green:0.231 blue:0.278 alpha:0.8];
  
   
  //头像图片
  self.userPhoto = [[UIImageView alloc]init];
  self.userPhoto.image = [UIImage imageNamed:@"UserPhoto.jpg"];
  self.userPhoto.frame = CGRectMake(0, 0, 80, 80);
  
  
  [self.userPhoto.layer setCornerRadius:CGRectGetHeight([self.userPhoto bounds])/2];
  self.userPhoto.layer.masksToBounds = true;
  
  
  
  
  self.userPhoto.center = CGPointMake((MAX_CENTER_X - centerX) * 3 / 5 , 80);
  [self.view addSubview:self.userPhoto];
  
  //头像下的名字
  UILabel *lblName = [[UILabel alloc]init];
  AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    lblName.text=appDelegate.username;
  //lblName.text = @"Paul Walker";
  lblName.font = [UIFont systemFontOfSize:12 weight:UIFontWeightUltraLight];
  lblName.textAlignment = NSTextAlignmentCenter;
  lblName.textColor = [UIColor whiteColor];
  CGFloat lblNameX = CGRectGetMinX(self.userPhoto.frame);
  CGFloat lblNameY = CGRectGetMaxY(self.userPhoto.frame) + 10;
  CGFloat lblNameW = self.userPhoto.frame.size.width;
  CGFloat lblNameH = 20;
  lblName.frame = CGRectMake(lblNameX, lblNameY, lblNameW, lblNameH);
  [self.view addSubview:lblName];
  
  /**
   *  先统一设置frame的一些值
   */
  CGFloat belowBtnX = CGRectGetMinX(self.userPhoto.frame);
  CGFloat belowBtnW = self.userPhoto.frame.size.width;
  CGFloat belowBtnH = 30;
  
  CGFloat lineX = CGRectGetMinX(self.userPhoto.frame) - 10;
  CGFloat lineW = self.userPhoto.frame.size.width + 20;
  CGFloat lineH = 1;
  
  //切换网络按钮
  UIButton *btnChangePhoto = [self belowButtonsWithTitle:@"切换网络"];
  CGFloat btnChangePhotoY = screen.size.height * 6 / 17;
  btnChangePhoto.frame = CGRectMake(belowBtnX, btnChangePhotoY, belowBtnW, belowBtnH);
  [self.view addSubview:btnChangePhoto];
  [btnChangePhoto addTarget:self action:@selector(btnChangePhotoClick) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *line1 = [[UIView alloc]init];
  CGFloat line1Y = CGRectGetMaxY(btnChangePhoto.frame) + 10;
  line1.frame = CGRectMake(lineX, line1Y, lineW, lineH);
  line1.backgroundColor = LINE_COLOR;
  [self.view addSubview:line1];
  
  //修改头像按钮
  UIButton *btnCompleteProfile = [self belowButtonsWithTitle:@"修改头像"];
  CGFloat btnCompleteProfileY = screen.size.height * 8 / 17;
  btnCompleteProfile.frame = CGRectMake(belowBtnX, btnCompleteProfileY, belowBtnW, belowBtnH);
  [self.view addSubview:btnCompleteProfile];
  [btnCompleteProfile addTarget:self action:@selector(btnCompleteProfileClick:) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *line2 = [[UIView alloc]init];
  CGFloat line2Y = CGRectGetMaxY(btnCompleteProfile.frame) + 10;
  line2.frame = CGRectMake(lineX, line2Y, lineW, lineH);
  line2.backgroundColor = LINE_COLOR;
  [self.view addSubview:line2];
  
  //修改密码按钮
  UIButton *btnModifyPassWord = [self belowButtonsWithTitle:@"修改密码"];
  CGFloat btnModifyPassWordY = screen.size.height * 10 / 17;
  btnModifyPassWord.frame = CGRectMake(belowBtnX, btnModifyPassWordY, belowBtnW, belowBtnH);
  [self.view addSubview:btnModifyPassWord];
  [btnModifyPassWord addTarget:self action:@selector(btnModifyPassWordClick) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *line3 = [[UIView alloc]init];
  CGFloat line3Y = CGRectGetMaxY(btnModifyPassWord.frame) + 10;
  line3.frame = CGRectMake(lineX, line3Y, lineW, lineH);
  line3.backgroundColor = LINE_COLOR;
  [self.view addSubview:line3];
  
  //修改邮箱按钮
  UIButton *btnModifyEmail = [self belowButtonsWithTitle:@"修改邮箱"];
  CGFloat btnModifyEmailY = screen.size.height * 12 / 17;
  btnModifyEmail.frame = CGRectMake(belowBtnX, btnModifyEmailY, belowBtnW, belowBtnH);
  [self.view addSubview:btnModifyEmail];
  [btnModifyEmail addTarget:self action:@selector(btnModifyEmailClick) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *line4 = [[UIView alloc]init];
  CGFloat line4Y = CGRectGetMaxY(btnModifyEmail.frame) + 10;
  line4.frame = CGRectMake(lineX, line4Y, lineW, lineH);
  line4.backgroundColor = LINE_COLOR;
  [self.view addSubview:line4];
  
  //账号注销按钮
  UIButton *btnAccountLogout = [self belowButtonsWithTitle:@"账号注销"];
  CGFloat btnAccountLogoutY = screen.size.height * 14 / 17;
  btnAccountLogout.frame = CGRectMake(belowBtnX, btnAccountLogoutY, belowBtnW, belowBtnH);
  [self.view addSubview:btnAccountLogout];
  [btnAccountLogout addTarget:self action:@selector(btnAccountLogoutClick) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *line5 = [[UIView alloc]init];
  CGFloat line5Y = CGRectGetMaxY(btnAccountLogout.frame) + 10;
  line5.frame = CGRectMake(lineX, line5Y, lineW, lineH);
  line5.backgroundColor = LINE_COLOR;
  [self.view addSubview:line5];
}


- (UIButton *)belowButtonsWithTitle:(NSString *)title{
  UIButton *btn = [[UIButton alloc]init];
  [btn setTitle:title forState:UIControlStateNormal];
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightUltraLight];
  return btn;
}


- (void)btnChangePhotoClick{
  
  NSLog(@"点击切换内外网按钮");
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  [AllUtils showPromptDialog:@"提示" andMessage:@"请选择网络环境" OKButton:@"外部网络" OKButtonAction:^(UIAlertAction *action) {
    //外网；
    app.isInternalNetworkGate = false;
    
    [MBProgressHUD showSuccess:@"您选择了外网"];
    
    NSLog(@"你选择了外网");
    
  } cancelButton:@"内部网络" cancelButtonAction:^(UIAlertAction *action) {
    
    //内网；
    app.isInternalNetworkGate = true;
    [MBProgressHUD showSuccess:@"您选择了内网"];
    
    NSLog(@"你选择了内网");
    
  } contextViewController:self];
}



- (void)btnModifyPassWordClick
{
  JYChangePwdViewController *changePwd=[[JYChangePwdViewController alloc]init];
  [self.navigationController pushViewController:changePwd animated:YES];
}

- (void)btnModifyEmailClick{
  
  
  CYFChangeMailViewController *changeMail = [[CYFChangeMailViewController alloc] init];
  [self.navigationController pushViewController:changeMail animated:true];
  
  
}

- (void)btnAccountLogoutClick
{
  //创建UIAlertView控件
  UIAlertView *logoutAlert=[[UIAlertView alloc]
                            initWithTitle:@"注销当前账号"//指定标题
                            message:@"注销当前账号需要重新登录"//指定消息
                            delegate:self//指定委托对象
                            cancelButtonTitle:@"取消"//为底部的取消按钮设置标题
                            otherButtonTitles:@"确定", nil];
  [logoutAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex==1)
  {
    //沙盒路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *file=[doc stringByAppendingPathComponent:@"account.data"];
    
    //清空沙盒内容
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:file error:nil];
    
    self.view.window.rootViewController=[[JYLoginViewController alloc]init];
  }
  else
  {
    
  }
}


#pragma mark - 从相册中取出图片

- (void)btnCompleteProfileClick:(id)sender{
  if ([self.imagePickerPopover isPopoverVisible]) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
    return;
  }
  
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.editing = YES;
  
  //如果设备支持相机，就使用拍照技术
  //否则让用户从照片库中选择照片
//  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//  {
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//  }
//  else{
//
//  }
  
  
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
  imagePicker.delegate = self;
  
  //允许编辑图片
  imagePicker.allowsEditing = YES;
  
  //创建UIPopoverController对象前先检查当前设备是不是ipad
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.imagePickerPopover.delegate = self;
    [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                    animated:YES];
  }
  else
  {
    [self presentViewController:imagePicker animated:YES completion:nil];
  }
  
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  //通过info字典获取选择的照片
  UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
  
  //以itemKey为键，将照片存入ImageStore对象中
  [[CYFImageStore sharedStore] setImage:image forKey:@"CYFStore"];
  
  //将照片放入UIImageView对象
  self.userPhoto.image = image;
  
  
  //判断是否已经设置头像；
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setValue:@"isSettedPhoto" forKey:@"isSettedPhoto"];
  

  //判断UIPopoverController对象是否存在
  if (self.imagePickerPopover) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
  }
  else
  {
    //关闭以模态形式显示的UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *isFirstInstall = [defaults valueForKey:@"isFirstInstall"];
  NSString *isSettedPhoto = [defaults valueForKey:@"isSettedPhoto"];
  
  //重新设置头像；
  if (isFirstInstall  == nil || isSettedPhoto == nil) {
    //第一次安装；
   
    UIImage *image = [UIImage imageNamed:@"UserPhoto"];
    self.userPhoto.image = image;
    
    
  }else{
    
    UIImage *image = [[CYFImageStore sharedStore] imageForKey:@"CYFStore"];
    self.userPhoto.image = image;
    
  }
}

@end






