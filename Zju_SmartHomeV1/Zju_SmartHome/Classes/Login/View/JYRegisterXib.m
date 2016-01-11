//
//  JYRegisterXib.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYRegisterXib.h"

@interface JYRegisterXib()

//注册
- (IBAction)registerGo:(id)sender;
//密码明文
- (IBAction)eyeSeePwd:(id)sender;
//眼睛图片
//@property (weak, nonatomic) IBOutlet UIButton *eyePicture;

- (IBAction)backClick:(id)sender;
//用户名view
@property (weak, nonatomic) IBOutlet UIView *userNameView;
//密码view
@property (weak, nonatomic) IBOutlet UIView *pwdView;
//邮箱view
@property (weak, nonatomic) IBOutlet UIView *emailView;

@end

@implementation JYRegisterXib

+(instancetype)registerXib
{
    JYRegisterXib *registerXib=[[[NSBundle mainBundle]loadNibNamed:@"JYRegister" owner:nil options:nil]lastObject];
    registerXib.eyePicture.hidden=YES;
    
    registerXib.userNameView.layer.cornerRadius=20;
    registerXib.userNameView.clipsToBounds=YES;
    registerXib.pwdView.layer.cornerRadius=20;
    registerXib.pwdView.clipsToBounds=YES;
    registerXib.emailView.layer.cornerRadius=20;
    registerXib.emailView.clipsToBounds=YES;
    
    [registerXib.username setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [registerXib.username setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [registerXib.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [registerXib.password setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [registerXib.email setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [registerXib.email setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    return registerXib;
}

- (IBAction)registerGo:(id)sender
{
    if([self.delegate respondsToSelector:@selector(registerXib:and:and:)])
    {
        [self.delegate registerXib:self.username.text and:self.password.text and:self.email.text];
    }
}

- (IBAction)eyeSeePwd:(id)sender
{
    if(self.password.secureTextEntry)
    {
        
        [self.eyePicture setImage:[UIImage imageNamed:@"login_icon_Browse"] forState:UIControlStateNormal];
        self.password.secureTextEntry=NO;
    }
    else
    {
       [self.eyePicture setImage:[UIImage imageNamed:@"login_icon_unBrowse"] forState:UIControlStateNormal];
        self.password.secureTextEntry=YES;
    }
}
- (IBAction)backClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(backClick)])
    {
        [self.delegate backClick];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.email resignFirstResponder];
}
@end
