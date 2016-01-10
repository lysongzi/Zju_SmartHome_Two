//
//  STUserInfoController.m
//  个人信息demo
//
//  Created by 123 on 16/1/8.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STUserInfoController.h"
#import "STUserInfoView.h"
#import "STUserInfoCell.h"
#import "UIImage+ST.h"
#import "CYFChangeMailViewController.h"
#import "JYChangePwdViewController.h"
#import "CYFMainViewController.h"

@interface STUserInfoController ()<UITableViewDataSource,UITableViewDelegate,STUserInfoViewDelegate>
@property(nonatomic,strong)STUserInfoView *userView;
@property(nonatomic,strong)NSArray *optionArray;
@end

@implementation STUserInfoController

-(NSArray *)optionArray
{
    if (_optionArray==nil) {
        NSArray *optArr=[NSArray arrayWithObjects:@"修改头像", @"修改邮箱",@"修改密码",nil];
        _optionArray=optArr;
    }
    return _optionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarItemButton];
    
    STUserInfoView *userView=[STUserInfoView initWithUserView];
    userView.frame=self.view.bounds;
    //用户名
    [userView.userName setTitle:@"胡淑婷" forState:UIControlStateNormal];
    //头像
    [userView.portraitBtn setBackgroundImage:[UIImage circleImageWithName:@"头像.jpg" borderWith:0 borderColor:nil] forState:UIControlStateNormal];
    
    //userView的代理
    userView.delegate=self;
    //tableView的代理
    userView.userActTableView.delegate=self;
    userView.userActTableView.dataSource=self;
    self.userView=userView;
    [self.view addSubview:userView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.optionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"infoCell";
    STUserInfoCell *infoCell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (infoCell==nil) {
        infoCell=[STUserInfoCell initWithUserInfoCell];
        [infoCell.descBtn setTitle:self.optionArray[indexPath.row] forState:UIControlStateNormal];
        
        UIColor *color=[[UIColor alloc]initWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];
        infoCell.selectedBackgroundView=[[UIView alloc]initWithFrame:infoCell.frame];
        infoCell.selectedBackgroundView.backgroundColor=color;
    }
    return infoCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=45;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSLog(@"修改头像");
    }
    else if (indexPath.row==1)
    {
        CYFChangeMailViewController *changEmailVc=[[CYFChangeMailViewController alloc]init];
        [self.navigationController pushViewController:changEmailVc animated:YES];
    }
    else
    {
        JYChangePwdViewController *changPwdVc=[[JYChangePwdViewController alloc]init];
        [self.navigationController pushViewController:changPwdVc animated:YES];
    }
}
#pragma mark-STUserInfoView的代理方法
-(void)goBack
{
    NSLog(@"退出登录");
}

- (void)setNaviBarItemButton
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"个人信息"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];

    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)leftBtnClicked
{
    
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        
        if ([controller isKindOfClass:[CYFMainViewController
                                       class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}

@end
