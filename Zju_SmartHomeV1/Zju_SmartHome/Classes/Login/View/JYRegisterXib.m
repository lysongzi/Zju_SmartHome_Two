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

@end

@implementation JYRegisterXib

+(instancetype)registerXib
{
    JYRegisterXib *registerXib=[[[NSBundle mainBundle]loadNibNamed:@"JYRegister" owner:nil options:nil]lastObject];
    registerXib.eyePicture.hidden=YES;
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
        
        [self.eyePicture setImage:[UIImage imageNamed:@"login_Browse"] forState:UIControlStateNormal];
        self.password.secureTextEntry=NO;
    }
    else
    {
       [self.eyePicture setImage:[UIImage imageNamed:@"login_unBrowse"] forState:UIControlStateNormal];
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
