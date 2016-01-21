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

@interface STResetPwdController ()<UITextFieldDelegate,STResetPwdViewDelegate>
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
    resetPwdView.password.delegate=self;
    [self.view addSubview:resetPwdView];
}

//UITextField监听事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.placeholder isEqualToString:@"请输入密码"])
    {
        self.resetPwdView.eyePicture.hidden=NO;
        textField.secureTextEntry=YES;
        [self.resetPwdView.eyePicture setImage:[UIImage imageNamed:@"login_icon_unBrowse"] forState:UIControlStateNormal];
    }
}
-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
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
    [titleView setText:@"重置密码"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
}

- (void)leftBtnClicked{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        
        if ([controller isKindOfClass:[VerifyViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}
#pragma mark-STResetPwdViewDelegate
-(void)resetPwdGoGoGo
{
    NSLog(@"密码重置了");
}
@end
