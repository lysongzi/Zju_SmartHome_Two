//
//  YSRGBPatternViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSRGBPatternViewController.h"
#import "YSNewPattern.h"

#define CELL_NUMBER 5
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface YSRGBPatternViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *patternNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *patterns;

@property (assign) NSInteger cellWidth;
@property (assign) NSInteger cellHeight;

@end

@implementation YSRGBPatternViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellWidth = UISCREEN_WIDTH / CELL_NUMBER;
    self.cellHeight = self.scrollView.frame.size.height;
    
    //初始化默认模型数据
    [self initPatternData];
    NSLog(@"已有模式数目：%lu", self.patterns.count);
    //初始化scrollView
    [self initScrollView];
}

- (void)initPatternData
{
    NSArray *names = @[@"柔和", @"舒适", @"明亮", @"跳跃", @"R", @"G", @"B"];;
    NSArray *logoNames = @[@"rouhe_icon", @"shushi_icon", @"mingliang_icon", @"tiaoyue_icon", @"R", @"G", @"B"];
    NSArray *bkgNames = @[@"rouhe_bg", @"shushi_bg", @"mingliang_bg", @"tiaoyue_bg", @"R_bg", @"G_bg", @"B_bg"];
    
    if (!self.patterns)
    {
        self.patterns = [NSMutableArray array];
    }
    
    //默认的模式
    for (int i = 0; i < names.count; i++) {
        YSNewPattern *pattern = [[YSNewPattern alloc] initWithName:names[i] logoName:logoNames[i] bkgName:bkgNames[i]];
        [self.patterns addObject:pattern];
    }
    
    //然后这里加入已保存的自定义的模式
    //。。。。。。。。。。。。。。。。
    
    //最后一个自定义按钮
    [self.patterns addObject:[[YSNewPattern alloc] initWithName:@"自定义" logoName:@"zidingyi"]];
}

- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(self.cellWidth * (self.patterns.count + 4), self.cellHeight);
    self.scrollView.contentOffset = CGPointMake(self.cellWidth * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = 0.95f;
    
    //添加两个空白的块
    for (int i = 0; i < 2; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.cellWidth * i, 0, self.cellWidth, self.cellHeight)];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth)];
        subView.backgroundColor = [UIColor clearColor];
        
        [view addSubview:subView];
        [self.scrollView addSubview:view];
    }
    
    //默认的六个块
    for (int i = 2; i < self.patterns.count + 2; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.cellWidth * i, 0, self.cellWidth, self.cellHeight)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth)];
        image.image = [UIImage imageNamed:[self.patterns[i-2] logoName]];
        NSLog(@"%@ %@", [self.patterns[i-2] name], [self.patterns[i-2] logoName]);
        [view addSubview:image];
        [self.scrollView addSubview:view];
    }
    
    //添加两个空白的块
    for (long i = self.patterns.count + 2; i < self.patterns.count + 4; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.cellWidth * i, 0, self.cellWidth, self.cellHeight)];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth)];
        subView.backgroundColor = [UIColor clearColor];
        
        [view addSubview:subView];
        [self.scrollView addSubview:view];
    }
}

- (IBAction)pictureClick:(id)sender
{
    NSLog(@"图片选择");
}

- (IBAction)musicClick:(id)sender
{
    NSLog(@"音乐选择");
}

#pragma mark - UIScrollViewDelegate 协议的实现

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cellJumpToIndex:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self cellJumpToIndex:scrollView];
    }
    
}

- (void)cellJumpToIndex:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x < self.cellWidth * 0.5)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (self.scrollView.contentOffset.x > self.cellWidth * (self.patterns.count + 1.5))
    {
        [self.scrollView setContentOffset:CGPointMake(self.cellWidth * (self.patterns.count + 1), 0) animated:YES];
    }
    
    int index = (int)(self.scrollView.contentOffset.x / self.cellWidth + 0.5);
    [self.scrollView setContentOffset:CGPointMake(self.cellWidth * index, 0) animated:YES];
    
    //选定某个模式，进行模式更新等操作
    [self updateCellBackground:index];
}

- (void)updateCellBackground:(int)index
{
    NSLog(@"%@", [self.patterns[index] bkgName]);
    self.patternNameLabel.text = [self.patterns[index] name];
    if (index != self.patterns.count - 1)
    {
        self.bkgImageView.image = [UIImage imageNamed:[self.patterns[index] bkgName]];
    }
    
}

@end
