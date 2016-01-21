//
//  JYRegisterViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/3.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYRegisterViewController.h"
#import "JYLoginViewController.h"
#import "JYRegisterXib.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@interface JYRegisterViewController ()<RegisterXibDelegate,UITextFieldDelegate>
@property(nonatomic,strong)JYRegisterXib *registerXib;
@end

@implementation JYRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    JYRegisterXib *registerXib=[JYRegisterXib registerXib];
    
    registerXib.delegate=self;
    registerXib.username.delegate=self;
    registerXib.password.delegate=self;
    registerXib.email.delegate=self;
    self.registerXib=registerXib;
    self.view=registerXib;
}

-(void)registerXib:(NSString *)username and:(NSString *)password and:(NSString *)email
{
    //显示一个蒙板
    [MBProgressHUD showMessage:@"正在注册中..."];
  
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"user.account"]=username;
    params[@"user.password"]=password;
    params[@"user.email"]=email;
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Passport/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //请求成功
         if([responseObject[@"code"] isEqualToString:@"0"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"注册成功"];
             JYLoginViewController *jyVc=[[JYLoginViewController alloc]init];
             self.view.window.rootViewController=jyVc;
           
         }
         else if ([responseObject[@"code"]isEqualToString:@"308"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"用户名或者邮箱重复"];
         
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"请求失败%@",error);
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"注册失败"];

     }];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   if([textField.placeholder isEqualToString:@"请输入密码"])
    {
        self.registerXib.eyePicture.hidden=NO;
//        [textField setText:@""];
        textField.secureTextEntry=YES;
        [self.registerXib.eyePicture setImage:[UIImage imageNamed:@"login_icon_unBrowse"] forState:UIControlStateNormal];
    }
}


-(void)backClick
{
    self.view.window.rootViewController=[[JYLoginViewController alloc]init];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
