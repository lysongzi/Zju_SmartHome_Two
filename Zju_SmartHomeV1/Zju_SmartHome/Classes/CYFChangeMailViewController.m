
//
//  CYFChangeMailViewController.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/12/5.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFChangeMailViewController.h"
#import "RESideMenu.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

@interface CYFChangeMailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldMail;

@property (weak, nonatomic) IBOutlet UITextField *mail;

@property (weak, nonatomic) IBOutlet UITextField *confirmNewMail;

@end

@implementation CYFChangeMailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setNavigationBar];
  
  self.oldMail.delegate=self;
  self.mail.delegate=self;
  self.confirmNewMail.delegate=self;
  
  
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
  [titleView setText:@"修改邮箱"];
  titleView.frame=CGRectMake(0, 0, 100, 16);
  titleView.font=[UIFont systemFontOfSize:16];
  [titleView setTextColor:[UIColor whiteColor]];
  titleView.textAlignment=NSTextAlignmentCenter;
  self.navigationItem.titleView=titleView;
  
}

- (void)leftBtnClicked{
  
  for (UIViewController *controller in self.navigationController.viewControllers) {
    
    if ([controller isKindOfClass:[RESideMenu class]]) {
      controller.navigationController.navigationBar.hidden=YES;
      [self.navigationController popToViewController:controller animated:YES];
      
    }
    
  }
}

//UITextField监听事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  if([textField.text isEqualToString:@"请输入原邮箱"])
  {
    [textField setText:@""];
//    textField.secureTextEntry=false;
  }
  else if([textField.text isEqualToString:@"请输入新邮箱"])
  {
    
    [textField setText:@""];
//    textField.secureTextEntry=YES;
  }
  else if([textField.text isEqualToString:@"请确认新邮箱"])
  {
    [textField setText:@""];
//    textField.secureTextEntry=YES;
  }
}


- (IBAction)changeMail:(id)sender
{
  
  NSLog(@"changeMail");
  //显示一个蒙板
  [MBProgressHUD showMessage:@"正在修改邮箱..."];
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  mgr.responseSerializer=[AFJSONResponseSerializer serializer];
  
  //3.封装请求参数
  NSMutableDictionary *params=[NSMutableDictionary dictionary];
  params[@"is_app"]=@"1";
  params[@"old"]=self.oldMail.text;
  params[@"new1"]=self.mail.text;
  params[@"new2"]=self.confirmNewMail.text;
  NSLog(@"%@ %@ %@",params[@"old"],params[@"new1"],params[@"new2"]);
  
  //4.发送请求
  [mgr POST:@"http://60.12.220.16:8888/paladin/User/email" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
     
//     NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     NSLog(@"服务器返回responseObject:%@",responseObject);

     
     NSLog(@"code:%@",responseObject[@"code"]);
     
     
     //请求成功
     if([responseObject[@"code"] isEqualToString:@"0"])
     {
       
       
       //移除遮盖
       [MBProgressHUD hideHUD];
       [MBProgressHUD showSuccess:@"邮箱修改成功"];
       
     }
     else if ([responseObject[@"code"]isEqualToString:@"310"])
     {
       //移除遮盖
       [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"原始邮箱不能为空"];
     }
     else if ([responseObject[@"code"]isEqualToString:@"311"])
     {
       //移除遮盖
       [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"原始邮箱错误"];
       
     }
     else if ([responseObject[@"code"]isEqualToString:@"312"])
     {
       //移除遮盖
       [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"新邮箱两次输入不一致"];
       
     }
     
   }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
   {
     [MBProgressHUD hideHUD];
     [MBProgressHUD showError:@"修改失败"];
     
   }];
  
}

@end














