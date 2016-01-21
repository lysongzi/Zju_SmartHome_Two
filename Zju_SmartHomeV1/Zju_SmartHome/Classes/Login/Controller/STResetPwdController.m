//
//  STResetPwdController.m
//  STResetPwd
//
//  Created by hst on 16/1/20.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "STResetPwdController.h"
#import "STResetPwdView.h"
#import "VerifyViewController.h"
#import "JYLoginViewController.h"

@interface STResetPwdController ()<STResetPwdViewDelegate>
@property(nonatomic,strong)STResetPwdView *resetPwdView;
@end

@implementation STResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    NSLog(@"%f %f",statusBarHeight, self.view.frame.size.width);
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    
    [navigationItem setTitle:NSLocalizedString(@"重置密码", nil)];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    
    [self.view addSubview:navigationBar];
    
//    [self setNavigationBar];
    STResetPwdView *resetPwdView=[STResetPwdView resetPwdView];
    resetPwdView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.resetPwdView=resetPwdView;
    resetPwdView.delegate=self;
    [self.view addSubview:resetPwdView];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

#pragma mark-STResetPwdViewDelegate
-(void)resetPwdWithUserName:(NSString *)userName andPwd:(NSString *)xinPwd
{
    NSLog(@"--%@--%@",userName,xinPwd);
    self.view.window.rootViewController=[[JYLoginViewController alloc]init];
}
@end
