//
//  YSPatternViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSPatternViewController.h"
#import "CYFMainViewController.h"
#import "YSPatternViewCell.h"
#import "YSProductViewController.h"
#import "YSPattern.h"

#define TABLE_SECTION 1;
#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEFAULT_CELL_WIDTH 320;
#define DEFAULT_CELL_HEIGHT 130;

@interface YSPatternViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *patterns;

@end

@implementation YSPatternViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.patterns = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"YSPatternViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YSPatternViewCell"];
    
    //设置数据源和委托对象
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    
    //设置导航条
    [self setNaviBarItemButton];
    
    YSPattern *p1 = [[YSPattern alloc] initWithPatternName:@"柔和模式" desc:@"Soft"];
    [self.patterns addObject:p1];
    
    YSPattern *p2 = [[YSPattern alloc] initWithPatternName:@"明亮模式" desc:@"Bright"];
    [self.patterns addObject:p2];
    
    YSPattern *p3 = [[YSPattern alloc] initWithPatternName:@"温暖模式" desc:@"Warm"];
    [self.patterns addObject:p3];
    
    YSPattern *p4 = [[YSPattern alloc] initWithPatternName:@"跳跃模式" desc:@"Jump"];
    [self.patterns addObject:p4];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource 协议的实现

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TABLE_SECTION;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count %ld", self.patterns.count);
    return  self.patterns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSPatternViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YSPatternViewCell"
                                                                   forIndexPath:indexPath];
    YSPattern *pattern = self.patterns[indexPath.row];
    cell.patternName.text = pattern.patternName;
    cell.descLabel.text = pattern.descLabel;
    
    return cell;
}

#pragma mark - UITableViewDelegate 协议的实现

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UISCREEN_WIDTH / 320) * 150;
    //return 130;
}

#pragma mark - 导航栏
- (void)setNaviBarItemButton
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"RGB灯"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    //左侧返回按钮
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //右侧切换模式
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(rightBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)leftBtnClicked
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[YSProductViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)rightBtnClicked
{
    //编辑按钮的操作
    NSLog(@"编辑操作...");
}


@end
