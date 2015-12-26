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
#import "MBProgressHUD+MJ.h"
#import "JYSqlite.h"
#import "DLLampControlRGBModeViewController.h"

#define TABLE_SECTION 1;
#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEFAULT_CELL_WIDTH 320;
#define DEFAULT_CELL_HEIGHT 130;

@interface YSPatternViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addPatternBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *patterns;

@property (weak, nonatomic) YSPattern *checkedPattern;
@property(nonatomic,strong)JYSqlite *jySqlite;

@end

@implementation YSPatternViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.patterns = [NSMutableArray array];
        [self initDefultPattern];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"我看看这个逻辑id是否传递过来了%@",self.logic_id);
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"YSPatternViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YSPatternViewCell"];
    
    
    //设置数据源和委托对象
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    //设置导航条
    [self setNaviBarItemButton];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    JYSqlite *jySqlite=[[JYSqlite alloc]init];
    jySqlite.patterns=[[NSMutableArray alloc]init];
    self.jySqlite=jySqlite;
    
    //打开数据库
    [self.jySqlite openDB];
    //创建表（如果已经存在时不会再创建的）
    [self.jySqlite createTable];
    //获取表中所有记录
    [self.jySqlite getAllRecord];
    self.patterns=self.jySqlite.patterns;
    
    [self.tableView reloadData];

}

//初始化默认的四个模式
- (void)initDefultPattern
{
    //柔和模式
//    YSPattern *soft = [[YSPattern alloc] initWithPatternName:@"柔和模式" desc:@"Soft" picture:@"soft_background"];
//    soft.isCheck = YES;
//    self.checkedPattern = soft;
//    [self.patterns addObject:soft];
//    
//    //明亮模式
//    YSPattern *bright = [[YSPattern alloc] initWithPatternName:@"明亮模式" desc:@"Bright" picture:@"bright_background"];
//    [self.patterns addObject:bright];
//    
//    //温暖模式
//    YSPattern *warm = [[YSPattern alloc] initWithPatternName:@"温暖模式" desc:@"Warm" picture:@"warm_background"];
//    [self.patterns addObject:warm];
//    
//    //跳跃模式
//    YSPattern *jump = [[YSPattern alloc] initWithPatternName:@"跳跃模式" desc:@"Jump" picture:@"shining_background"];
//    [self.patterns addObject:jump];
    

    //初始化
    JYSqlite *jySqlite=[[JYSqlite alloc]init];
    jySqlite.patterns=[[NSMutableArray alloc]init];
    self.jySqlite=jySqlite;
    
    //打开数据库
    [self.jySqlite openDB];
    //创建表（如果已经存在时不会再创建的）
    [self.jySqlite createTable];
    //获取表中所有记录
    [self.jySqlite getAllRecord];
    
    //self.patterns=jySqlite.patterns;
    if(self.jySqlite.patterns.count==0)
    {
        NSLog(@"暂时还没有数据");
        [self.jySqlite insertRecordIntoTableName:@"patternTable" withField1:@"name" field1Value:@"柔和模式" andField2:@"desc" field2Value:@"Soft" andField3:@"img" field3Value:@"soft_background" andField4:@"rValue" field4Value:@"100" andField5:@"gValue" field5Value:@"99" andField6:@"bValue" field6Value:@"98"];
        
        [self.jySqlite insertRecordIntoTableName:@"patternTable" withField1:@"name" field1Value:@"明亮模式" andField2:@"desc" field2Value:@"Bright" andField3:@"img" field3Value:@"bright_background" andField4:@"rValue" field4Value:@"100" andField5:@"gValue" field5Value:@"99" andField6:@"bValue" field6Value:@"98"];
        
        [self.jySqlite insertRecordIntoTableName:@"patternTable" withField1:@"name" field1Value:@"温暖模式" andField2:@"desc" field2Value:@"Bright" andField3:@"img" field3Value:@"warm_background" andField4:@"rValue" field4Value:@"100" andField5:@"gValue" field5Value:@"99" andField6:@"bValue" field6Value:@"98"];
        
        [self.jySqlite insertRecordIntoTableName:@"patternTable" withField1:@"name" field1Value:@"跳跃模式" andField2:@"desc" field2Value:@"Bright" andField3:@"img" field3Value:@"shining_background" andField4:@"rValue" field4Value:@"100" andField5:@"gValue" field5Value:@"99" andField6:@"bValue" field6Value:@"98"];
        [self.jySqlite getAllRecord];
        self.patterns=self.jySqlite.patterns;
        for(int i=0;i<self.patterns.count;i++)
        {
            YSPattern *pattern=self.patterns[i];
            if(i==0)
            {
                pattern.isCheck=YES;
                self.checkedPattern =pattern;

            }
            else
            {
                pattern.isCheck=NO;
                
            }
        }
       // NSLog(@"长度%ld",self.patterns.count);
    }
    else
    {
        NSLog(@"已经有数据了");
        self.patterns=self.jySqlite.patterns;
        //NSLog(@"长度%ld",self.patterns.count);
        for(int i=0;i<self.patterns.count;i++)
        {
            YSPattern *pattern=self.patterns[i];
            if(i==0)
            {
                pattern.isCheck=YES;
                 self.checkedPattern =pattern;
            }
            else
            {
                pattern.isCheck=NO;
            }
        }
    }
   
}

//- (void)updateScrollView
//{
//    self.mainScrollView.contentSize = CGSizeMake(UISCREEN_WIDTH, self.tableView.contentSize.height + self.addPatternBtn.frame.size.height + 14);
//}

#pragma mark - UITableViewDataSource 协议的实现

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TABLE_SECTION;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.picture.image = [UIImage imageNamed:pattern.imgKey];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (pattern.isCheck)
    {
        cell.checkPic.hidden = NO;
    }
    else
    {
        cell.checkPic.hidden = YES;
    }
    [cell.changeRgbGo addTarget:self action:@selector(clickGO:) forControlEvents:UIControlEventTouchUpInside];

    //[self updateScrollView];
    return cell;
}

//被选中的cell的处理事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSPattern *selectedPattern = self.patterns[indexPath.row];
    //当前已经是被选中的
    if (selectedPattern.isCheck)
    {
        return;
    }
    //设置原来被选中的为未选中
    self.checkedPattern.isCheck = NO;
    //设定新的选中cell
    selectedPattern.isCheck = YES;
    self.checkedPattern = selectedPattern;
    [self.tableView reloadData];
    
    //接下来是各种控制灯的实现
    NSLog(@"开始控制灯咯");
}

#pragma mark - UITableViewDelegate 协议的实现

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UISCREEN_WIDTH / 320) * 130;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        YSPattern *pattern=self.patterns[indexPath.row];
        //打开数据库
        [self.jySqlite openDB];
        [self.jySqlite deleteRecordWithName:pattern.patternName];
        
        [self.patterns removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @" 删除 ";
}

#pragma mark 模式界面相关操作

- (IBAction)addPattern:(id)sender {
    //这里是添加新的模式的操作
    [MBProgressHUD showError:@"不给你添加，咬我啊.."];
}


#pragma mark - 导航栏
- (void)setNaviBarItemButton
{
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:@"RGB灯"];
    titleView.frame = CGRectMake(0, 0, 100, 16);
    titleView.font = [UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    
    //左侧返回按钮
    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
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


-(void)clickGO:(id)sender
{
    UIView *v = [sender superview];//获取父类view
    YSPatternViewCell *cell = (YSPatternViewCell *)[v superview];//获取cell
     NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];//获取cell对应的indexpath;
    YSPattern *pattern=self.patterns[indexpath.row];

    NSLog(@"我看看点击的是哪一个%ld  %@",indexpath.row,pattern.patternName);
    
    DLLampControlRGBModeViewController *rgbController=[[DLLampControlRGBModeViewController alloc]init];
    rgbController.logic_id=self.logic_id;
    rgbController.patternName=pattern.patternName;
    [self.navigationController pushViewController:rgbController animated:YES];

}


@end
