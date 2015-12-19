//
//  JYLoginXib.m
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYLoginXib.h"

@interface  JYLoginXib()
////用户名
//@property (weak, nonatomic) IBOutlet UITextField *username;
////密码
//@property (weak, nonatomic) IBOutlet UITextField *password;
//密码明文
- (IBAction)eyeSeePwd:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *eyePicture;
//登录
- (IBAction)loginGo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


- (IBAction)forgetPassword;
- (IBAction)register;

@end
@implementation JYLoginXib

+(instancetype)loginXib
{
    JYLoginXib *loginXib=[[[NSBundle mainBundle]loadNibNamed:@"loginXib" owner:nil options:nil]lastObject];
    loginXib.eyePicture.hidden=YES;
    return loginXib;
}



//密码明文
- (IBAction)eyeSeePwd:(id)sender
{
    if(self.password.secureTextEntry)
    {
        self.password.secureTextEntry=NO;
        [self.eyePicture setImage:[UIImage imageNamed:@"login_Browse"] forState:UIControlStateNormal];
        [self.eyePicture setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    else
    {
        self.password.secureTextEntry=YES;
        [self.eyePicture setImage:[UIImage imageNamed:@"login_unBrowse"] forState:UIControlStateNormal];
    }
}

//登录
- (IBAction)loginGo:(id)sender
{
   
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pressed"] forState:UIControlStateHighlighted];
    if([self.delegate respondsToSelector:@selector(loginGoGoGo:and:)])
    {
        [self.delegate loginGoGoGo:self.username.text and:self.password.text];
    }
  
  [self.username resignFirstResponder];
  [self.password resignFirstResponder];
}

//忘记密码
- (IBAction)forgetPassword {
    if([self.delegate respondsToSelector:@selector(forgetPasswordGO)])
    {
        [self.delegate forgetPasswordGO];
    }
}

//注册
- (IBAction)register
{
    if([self.delegate respondsToSelector:@selector(registerGoGoGo)])
    {
        [self.delegate registerGoGoGo];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

  [self.username resignFirstResponder];
  [self.password resignFirstResponder];
}



@end
