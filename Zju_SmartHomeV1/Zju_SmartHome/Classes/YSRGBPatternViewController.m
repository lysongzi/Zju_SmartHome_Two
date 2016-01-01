//
//  YSRGBPatternViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSRGBPatternViewController.h"
#import "YSProductViewController.h"
#import "YSNewPattern.h"

#define CELL_NUMBER 5
#define DEFAULT_CELL_NUMBER 7
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface YSRGBPatternViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *patternNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *patterns;
@property (strong, nonatomic) NSMutableArray *cellsView;

@property (assign) NSInteger cellWidth;
@property (assign) NSInteger cellHeight;

@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSArray *logoNames;
@property (strong, nonatomic) NSArray *bkgNames;

//记录当前居中的模式索引
@property (assign) NSInteger selectedIndex;

@end

@implementation YSRGBPatternViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviBarItemButton];
    
    self.cellWidth = UISCREEN_WIDTH / CELL_NUMBER;
    self.cellHeight = self.scrollView.frame.size.height;
    
    if (!self.names)
    {
        self.names = @[@"柔和", @"舒适", @"明亮", @"跳跃", @"R", @"G", @"B"];
    }
    
    if (!self.logoNames)
    {
        self.logoNames = @[@"rouhe_icon", @"shushi_icon", @"mingliang_icon", @"tiaoyue_icon", @"R", @"G", @"B"];
    }
    
    if (!self.bkgNames)
    {
        self.bkgNames = @[@"rouhe_bg", @"shushi_bg", @"mingliang_bg", @"tiaoyue_bg", @"R_bg", @"G_bg", @"B_bg"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //初始化默认模型数据
    [self initPatternData];
    
    //初始化scrollView
    [self initScrollView];
}

//初始化模式的数据
- (void)initPatternData
{
    
    if (!self.patterns)
    {
        self.patterns = [NSMutableArray array];
    }
    
    //默认的模式
    for (int i = 0; i < self.names.count; i++) {
        YSNewPattern *pattern = [[YSNewPattern alloc] initWithName:self.names[i] logoName:self.logoNames[i] bkgName:self.bkgNames[i]];
        [self.patterns addObject:pattern];
    }
    
    //然后这里加载已保存的自定义的模式
    //。。。。。。。。。。。。。。。。
    [self addPatternToScrollView:[[YSNewPattern alloc] initWithName:@"自定义1" logoName:@"mingliang_icon" bkgName:@"mingliang_bg"]];
    
    //最后一个自定义按钮
    [self.patterns addObject:[[YSNewPattern alloc] initWithName:@"自定义" logoName:@"zidingyi"]];
}

//初始化scrollView的内容
- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(self.cellWidth * (self.patterns.count + 4), self.cellHeight);
    self.scrollView.contentOffset = CGPointMake(self.cellWidth * 2, 0);
    self.selectedIndex = 2;
    
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = 0.95f;
    
    if (!self.cellsView)
    {
        self.cellsView = [NSMutableArray array];
    }
    
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
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.cellWidth - 10, self.cellWidth - 10)];
        image.image = [UIImage imageNamed:[self.patterns[i-2] logoName]];
        image.tag = i - 2;
        
        //添加按钮添加触摸手势
        if (i == self.patterns.count + 1)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapGestureEvent:)];
            [image addGestureRecognizer:tap];
            [image setUserInteractionEnabled:YES];
        }
        //别的模式点击进入模式编辑和向上删除滑动删除手势
        else
        {
            //添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(patternTapGestureEvent:)];
            [image addGestureRecognizer:tap];
            
            //添加向上滑手势
            UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDeletePattern:)];
            [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
            [image addGestureRecognizer:swipeGesture];
            
            [image setUserInteractionEnabled:YES];
        }
        
        [view addSubview:image];
        [self.cellsView addObject:image];
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
    
    //设置背景颜色和文字
    [self updateCellBackground:2];
}

//添加按钮的添加模式事件
- (void)addTapGestureEvent:(UIGestureRecognizer *)gr
{
    UIImageView *image = (UIImageView *)gr.self.view;
    
    //被点击的不是居中的元素，则进行滑动
    if (image.tag != self.selectedIndex)
    {
        float destination = self.scrollView.contentOffset.x + (image.tag - self.selectedIndex) * self.cellHeight;
        self.selectedIndex = image.tag;
        [self.scrollView setContentOffset:CGPointMake(destination, 0) animated:YES];
    }
    //否则就是点击了居中的元素
    else
    {
        NSLog(@"进入添加新模式的界面");
    }
}

//编辑模式事件
- (void)patternTapGestureEvent:(UIGestureRecognizer *)gr
{
    UIImageView *image = (UIImageView *)gr.self.view;
    
    //被点击的不是居中的元素，则进行滑动
    if (image.tag != self.selectedIndex)
    {
        float destination = self.scrollView.contentOffset.x + (image.tag - self.selectedIndex) * self.cellHeight;
        self.selectedIndex = image.tag;
        [self.scrollView setContentOffset:CGPointMake(destination, 0) animated:YES];
    }
    //否则就是点击了居中的元素
    else
    {
        NSLog(@"进入编辑模式的界面");
    }
}

//向上滑动删除
- (void)swipeToDeletePattern:(UIGestureRecognizer *)gr
{
    NSLog(@"向上滑动删除函数进来了");
    UIImageView *image = (UIImageView *)gr.self.view;
    
    //想删除的不是居中的元素，或者默认模式不允许删除，或者是添加按钮键
    if (image.tag != self.selectedIndex || self.selectedIndex < DEFAULT_CELL_NUMBER || image.tag == self.patterns.count - 1)
    {
        return;
    }
    
    NSLog(@"接下来开始删除了");
}

//点击图片取色按钮的响应事件
- (IBAction)pictureClick:(id)sender
{
    NSLog(@"图片选择");
}

//点击播放音乐的响应事件
- (IBAction)musicClick:(id)sender
{
    NSLog(@"音乐选择");
}

#pragma mark - scrollView中cell的动态操作

- (void)addPatternToScrollView:(YSNewPattern *)pattern
{
    //先把该模式添加到数组中
    [self.patterns insertObject:pattern atIndex:self.patterns.count];
    
    //然后添加到scrollView中
    //待定
}

- (void)deletePatternFromScrollView:(YSNewPattern *)pattern
{
    //从模型中删除
    [self.patterns removeObjectAtIndex:self.selectedIndex];
}

#pragma mark - UIScrollViewDelegate 协议的实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cellJumpToIndex:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self cellJumpToIndex:scrollView];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (targetContentOffset->x >= (self.patterns.count - 1) * self.cellWidth)
    {
        [self updateCellBackground:(int)self.patterns.count - 1];
    }
    else if(targetContentOffset->x <= 0)
    {
        //变得太快了
        //[self updateCellBackground:0];
    }
}

//滑动的时候就会调用的函数，在这里写动画？
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
}

//滑动动画结束时调用的函数
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //根据居中的选项更新背景和文字
    [self updateCellBackground:(int)self.selectedIndex];
}

//计算位置，居中选中的cell
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
    self.selectedIndex = index;
    //[self updateCellBackground:index];
}

//滑动到某个cell时更新视图的方法
- (void)updateCellBackground:(int)index
{
    //NSLog(@"%@", [self.patterns[index] bkgName]);
    self.patternNameLabel.text = [self.patterns[index] name];
    
    //如果是添加模式按钮则不修改图片
    if (index != self.patterns.count - 1)
    {
        self.bkgImageView.image = [UIImage imageNamed:[self.patterns[index] bkgName]];
    }
    
}

#pragma mark - 设置导航栏的按钮
- (void)setNaviBarItemButton{
    
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:@"RGB"];
    titleView.frame = CGRectMake(0, 0, 100, 16);
    titleView.font = [UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ct_icon_switch-unpress"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick:)];
    rightButton.tag = 0;
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightButtonClick:(id)sender
{
    //0表示为关灯状态，1表示开灯状态
    UIBarButtonItem *swichButton = (UIBarButtonItem *)sender;
    NSLog(@"%ld", swichButton.tag);
    
    //关灯变开灯
    if (!swichButton.tag)
    {
        swichButton.tag = 1;
        //[swichButton setImage:[UIImage imageNamed:@"ct_icon_switch-press"]];
    }
    //开灯变关灯
    else
    {
        swichButton.tag = 0;
        //[swichButton setImage:[UIImage imageNamed:@"ct_icon_switch-unpress"]];
    }
}

- (void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
