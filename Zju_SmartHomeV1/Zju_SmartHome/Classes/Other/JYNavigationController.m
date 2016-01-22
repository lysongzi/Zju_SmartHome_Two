//
//  JYNavigationController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYNavigationController.h"

@interface JYNavigationController ()

@end

@implementation JYNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    for(UIView *view in self.navigationBar.subviews)
    {
        if([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
        {
            //[view removeFromSuperview];
            view.alpha=1;
        }
    }
}
//一个类只会调用一次
+(void)initialize
{
    
    //1.设置导航栏的主题
    [self setupNavBarTheme];
    
    //2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
}


//设置导航栏的主题
+(void)setupNavBarTheme
{
  

    //1.去除apperance对象
    
    UINavigationBar *navBar=[UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
    [navBar setBarTintColor:[UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1]];
    navBar.translucent = YES;
   

    //2.设置标题属性
    //设置标题属性
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:18];
    textAttrs[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont]=[UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:textAttrs];
    
    
    //去掉导航栏但会按钮自带的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
forBarMetrics:UIBarMetricsDefault];
}

//设置导航栏按钮主题
+(void)setupBarButtonItemTheme
{
    UIBarButtonItem *item=[UIBarButtonItem appearance];
  
//  self.navigationController.navigationItem.hidesBackButton = true;
  
    //设置文字属性
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor]=[UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont]=[UIFont systemFontOfSize:16];
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
