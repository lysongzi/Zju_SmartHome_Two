//
//  YSSoftwareViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/11.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSSoftwareViewController.h"

@interface YSSoftwareViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation YSSoftwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //进行适配6
    float width = [[UIScreen mainScreen] bounds].size.width;
    float ratio = 1.0f;
    
    if (width == 320.0)
    {
        //5或5s
    }
    else if (width == 375.0)
    {
        ratio = 375.0 / 320.0;
        
    }
    else if (width == 414.0)
    {
        ratio = 414.0 / 320.0;
    }
    
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, self.image.frame.size.height * ratio);
    self.scrollView.bounces = NO;
    
    [self setNaviBarItemButton];
}

/**
 *  是否正在手势返回中的标示状态
 */
static BOOL _isPoping;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_isPoping)
    {
        _isPoping = YES;
        return YES;
    }
    return NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    //在didAppear时置为NO
    _isPoping = NO;
}

#pragma mark - 设置导航栏的按钮
- (void)setNaviBarItemButton{
    
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:@"功能介绍"];
    titleView.frame = CGRectMake(0, 0, 100, 16);
    titleView.font = [UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
