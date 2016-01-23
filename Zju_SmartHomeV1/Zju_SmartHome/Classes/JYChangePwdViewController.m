//
//  JYChangePwdViewController.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/3.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYChangePwdViewController.h"
#import "STUserInfoController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

@interface JYChangePwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *confirmNewPwd;
- (IBAction)changePwd:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *originPwdView;
@property (weak, nonatomic) IBOutlet UIView *xinPwdView;
@property (weak, nonatomic) IBOutlet UIView *surePwdView;

@end

@implementation JYChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBar];
    
    self.oldPwd.delegate=self;
    self.password.delegate=self;
    self.confirmNewPwd.delegate=self;
    
    self.originPwdView.layer.cornerRadius=20;
    self.originPwdView.clipsToBounds=YES;
    self.xinPwdView.layer.cornerRadius=20;
    self.xinPwdView.clipsToBounds=YES;
    self.surePwdView.layer.cornerRadius=20;
    self.surePwdView.clipsToBounds=YES;
    
    [self.oldPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.oldPwd setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.confirmNewPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmNewPwd setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
}

-(void)setNavigationBar
{
    self.navigationController.navigationBar.hidden=NO;
    
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"修改密码"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;

}


- (void)leftBtnClicked
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[STUserInfoController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}

//UITextField监听事件
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if([textField.text isEqualToString:@"请输入原密码"])
//    {
//        [textField setText:@""];
//        textField.secureTextEntry=YES;
//    }
//    else if([textField.text isEqualToString:@"请输入新密码"])
//    {
//        
//        [textField setText:@""];
//        textField.secureTextEntry=YES;
//    }
//    else if([textField.text isEqualToString:@"请确认新密码"])
//    {
//        [textField setText:@""];
//        textField.secureTextEntry=YES;
//    }
//}
- (IBAction)changePwd:(id)sender
{
    //显示一个蒙板
    [MBProgressHUD showMessage:@"正在修改密码..."];
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"old"]=self.oldPwd.text;
    params[@"new1"]=self.password.text;
    params[@"new2"]=self.confirmNewPwd.text;
    NSLog(@"%@ %@ %@",params[@"old"],params[@"new1"],params[@"new2"]);
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/User/password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //请求成功
         if([responseObject[@"code"] isEqualToString:@"0"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"密码修改成功"];
             
         }
         else if ([responseObject[@"code"]isEqualToString:@"310"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"原始密码不能为空"];
         }
         else if ([responseObject[@"code"]isEqualToString:@"311"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"原始密码错误"];
             
         }
         else if ([responseObject[@"code"]isEqualToString:@"312"])
         {
             //移除遮盖
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"新密码两次输入不一致"];
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"修改失败"];

     }];

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.oldPwd resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmNewPwd resignFirstResponder];
}
@end
