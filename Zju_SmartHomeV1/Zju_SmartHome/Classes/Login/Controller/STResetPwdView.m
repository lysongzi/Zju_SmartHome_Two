//
//  JYLoginXib.m
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "STResetPwdView.h"

@interface  STResetPwdView()


@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;
//重置密码
- (IBAction)resetPwdGo:(id)sender;


@end

@implementation STResetPwdView

+(instancetype)resetPwdView
{
    STResetPwdView *resetPwdView=[[[NSBundle mainBundle]loadNibNamed:@"STResetPwdView" owner:nil options:nil]lastObject];
    resetPwdView.password.secureTextEntry=YES;
    [resetPwdView.userName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [resetPwdView.userName setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [resetPwdView.password setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [resetPwdView.password setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    return resetPwdView;
}

//重置密码
- (IBAction)resetPwdGo:(id)sender
{
    [self.resetPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pressed"] forState:UIControlStateHighlighted];
    if([self.delegate respondsToSelector:@selector(resetPwdWithUserName:andPwd:)])
    {
        [self.delegate resetPwdWithUserName:self.userName.text andPwd:self.password.text];
    }
    [self.password resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.password resignFirstResponder];
}
@end
