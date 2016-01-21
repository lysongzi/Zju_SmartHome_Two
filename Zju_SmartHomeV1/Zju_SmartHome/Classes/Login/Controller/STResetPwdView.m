//
//  JYLoginXib.m
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "STResetPwdView.h"

@interface  STResetPwdView()

//密码明文
- (IBAction)eyeSeePwd:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *eyePicture;

@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;
//重置密码
- (IBAction)resetPwdGo:(id)sender;

//密码view
@property (weak, nonatomic) IBOutlet UIView *pwdView;

@end

@implementation STResetPwdView

+(instancetype)resetPwdView
{
    STResetPwdView *resetPwdView=[[[NSBundle mainBundle]loadNibNamed:@"STResetPwdView" owner:nil options:nil]lastObject];
    resetPwdView.eyePicture.hidden=YES;
//    resetPwdView.pwdView.layer.cornerRadius=20;
//    resetPwdView.pwdView.clipsToBounds=YES;
    [resetPwdView.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [resetPwdView.password setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    return resetPwdView;
}



//密码明文
- (IBAction)eyeSeePwd:(id)sender
{
    if(self.password.secureTextEntry)
    {
        self.password.secureTextEntry=NO;
        [self.eyePicture setImage:[UIImage imageNamed:@"login_icon_Browse"] forState:UIControlStateNormal];
        [self.eyePicture setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else
    {
        self.password.secureTextEntry=YES;
        [self.eyePicture setImage:[UIImage imageNamed:@"login_icon_unBrowse"] forState:UIControlStateNormal];
    }
}

//重置密码
- (IBAction)resetPwdGo:(id)sender
{
    [self.resetPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pressed"] forState:UIControlStateHighlighted];
    if([self.delegate respondsToSelector:@selector(resetPwdGoGoGo)])
    {
        [self.delegate resetPwdGoGoGo];
    }
    [self.password resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.password resignFirstResponder];
}
@end
