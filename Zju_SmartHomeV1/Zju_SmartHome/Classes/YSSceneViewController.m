//
//  YSSceneViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSSceneViewController.h"
#import "YSScene.h"
#import "JYSceneSqlite.h"
#import "HttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "LYSImageStore.h"
#import "JYFurniture.h"
#import "JYFurnitureParam.h"
#import "JYSceneSqlite.h"
#import "AppDelegate.h"
#import "YSSceneBackStatus.h"
#import "STNewSceneController.h"
#import "JYSceneOnly.h"
#import "STEditSceneController.h"

#define CELL_NUMBER 5
#define DEFAULT_CELL_NUMBER 6
#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface YSSceneViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *patternNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
//图片选择按钮
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
//音乐播放按钮
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

//音乐播放框
@property (weak, nonatomic) IBOutlet UIView *musicView;
//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *musicPlay;
//上一首
@property (weak, nonatomic) IBOutlet UIButton *musicPre;
//下一首
@property (weak, nonatomic) IBOutlet UIButton *musicNext;
//音乐框背景图
@property (weak, nonatomic) IBOutlet UIImageView *musicBkg;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//存放场景的数组(包括了灯的参数值)
@property (strong, nonatomic) NSMutableArray *scenes;
//单纯存放场景的数组
@property(nonatomic,strong)NSMutableArray *scenesOnly;

@property (strong, nonatomic) NSMutableArray *cellsView;

@property (assign) NSInteger cellWidth;
@property (assign) NSInteger cellHeight;

//音乐盒当前状态
@property (copy, nonatomic) NSString *musicBox_State;

//记录音乐框里各种空间位置的参数
@property CGRect musicViewFrame;
@property CGRect musicBkgFrame;
@property CGRect musicPreFrame;
@property CGRect musicNextFrame;
@property CGRect musicPlayFrame;

//记录当前居中的模式索引
@property (assign) NSInteger selectedIndex;
//定义JYSqlite对象
@property (nonatomic,strong) JYSceneSqlite *jySceneSqlite;

@property CGRect music;

//有关照片切换背景图的属性；
@property (nonatomic,strong) UIPopoverController *imagePickerPopover;
@property (nonatomic,strong) UIAlertController *alert;

@property(nonatomic,copy)NSString *tableName;

//传递到编辑界面的区域和场景名称和电器数组
@property(nonatomic,copy)NSString *edit_Area;
@property(nonatomic,copy)NSString *edit_sceneName;
@property(nonatomic,strong)NSMutableArray *editFurnitureArray;

@end

@implementation YSSceneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //存储某区域某场景下电器的表
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.tableName=[NSString stringWithFormat:@"sceneTable%@",appDelegate.user_id];
    NSLog(@"看看表名%@",self.tableName);
    NSLog(@"看看区域名称传过来没%@",self.sectionName);
    
    //查看当前区域下有哪些电器
    for(int i=0;i < self.furnitureArray.count;i++)
    {
        JYFurniture *furniture=self.furnitureArray[i];
        NSLog(@"ooooo %@ %@ %@",furniture.logic_id,furniture.descLabel,furniture.deviceType);
    }
    self.editFurnitureArray=[[NSMutableArray alloc]init];
    [self setNaviBarItemButton];
    
    self.cellWidth = UISCREEN_WIDTH / CELL_NUMBER;
    self.cellHeight = self.scrollView.frame.size.height;
    
    [self.switchButton setBackgroundImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateHighlighted];
    [self.musicButton setBackgroundImage:[UIImage imageNamed:@"music_icon_press"] forState:UIControlStateHighlighted];
    
    //初始化默认模型数据
    [self initPatternData];
    
    //初始化音乐框
    float gap = self.musicButton.frame.size.width / 2;
    
    self.musicViewFrame = self.musicView.frame;
    self.musicBkgFrame = self.musicBkg.frame;
    self.musicNextFrame = self.musicNext.frame;
    self.musicPreFrame = self.musicPre.frame;
    self.musicPlayFrame = self.musicPlay.frame;
    
    //默认不显示
    self.musicView.frame = CGRectMake(self.musicViewFrame.origin.x + self.musicViewFrame.size.width - gap, self.musicViewFrame.origin.y, 0, self.musicViewFrame.size.height);
    
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
    
    self.musicViewFrame = CGRectMake(self.musicViewFrame.origin.x * ratio, self.musicViewFrame.origin.y * ratio, self.musicViewFrame.size.width * ratio, self.musicViewFrame.size.height * ratio);
    
    self.musicBkgFrame = CGRectMake(self.musicBkgFrame.origin.x * ratio, self.musicBkgFrame.origin.y * ratio, self.musicBkgFrame.size.width * ratio, self.musicBkgFrame.size.height * ratio);
    
    self.musicNextFrame = CGRectMake(self.musicNextFrame.origin.x * ratio, self.musicNextFrame.origin.y * ratio, self.musicNextFrame.size.width * ratio, self.musicNextFrame.size.height * ratio);
    
    self.musicPlayFrame = CGRectMake(self.musicPlayFrame.origin.x * ratio, self.musicPlayFrame.origin.y * ratio, self.musicPlayFrame.size.width * ratio, self.musicPlayFrame.size.height * ratio);
    
    self.musicPreFrame = CGRectMake(self.musicPreFrame.origin.x * ratio, self.musicPreFrame.origin.y * ratio, self.musicPreFrame.size.width * ratio, self.musicPreFrame.size.height * ratio);
    
    
    //0表示未弹出状态，1表示弹出状态
    self.musicView.tag = 0;
    //0表示暂停状态，1表示播放状态
    self.musicPlay.tag = 0;
    
    //设置各种按钮点击图片
    [self.musicNext setBackgroundImage:[UIImage imageNamed:@"music_xiayishou_icon_press"] forState:UIControlStateHighlighted];
    [self.musicPre setBackgroundImage:[UIImage imageNamed:@"music_shangyishou_icon_press"] forState:UIControlStateHighlighted];
    
    self.switchButton.tag = 0;
    [self initMusicBox];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.tag_Back==2)
    {
        //初始化默认模型数据
        [self initPatternData];
        //初始化scrollView
        //[self initScrollView];
        
        //定位到新添加的模式
        [self.scrollView setContentOffset:CGPointMake(self.cellWidth * (self.scenesOnly.count - 2), 0)];
        //设置当前居中为新添加的模式，并更新背景和文字
        self.selectedIndex = self.scenesOnly.count - 2;
        [self updateCellBackground:(int)self.selectedIndex];
        self.tag_Back = 0;
    }
    else
    {
        NSLog(@"这里应该是修改模式背景图片返回来的");
    }
    
}

- (void)initMusicBox
{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    self.musicBox_State = [userDefault valueForKey:@"music_state"];
    
    if ([self.musicBox_State isEqualToString:@"stop"])
    {
        self.musicPlay.tag = 0;
        
        [self.musicPlay setBackgroundImage:[UIImage imageNamed:@"music_zanting"] forState:UIControlStateNormal];
    }
    else if ([self.musicBox_State isEqualToString:@"start"])
    {
        self.musicPlay.tag = 1;
        [self.musicPlay setBackgroundImage:[UIImage imageNamed:@"music_bofang"] forState:UIControlStateNormal];
    }
    else
    {
        //默认开启音乐盒并播放
        [HttpRequest getMusicActionfromProtol:@"power_on" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"请求成功：%@",result);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
}

//初始化模式的数据
- (void)initPatternData
{
    //初始化
    JYSceneSqlite *jySceneSqlite = [[JYSceneSqlite alloc]init];
    jySceneSqlite.patterns = [[NSMutableArray alloc]init];
    jySceneSqlite.scenesOnly=[[NSMutableArray alloc]init];
    self.jySceneSqlite = jySceneSqlite;
    
    //打开数据库
    [self.jySceneSqlite openDB];
    //创建表（如果已经存在时不会再创建的）
    [self.jySceneSqlite createTable:self.tableName];
    
    //获取表中指定逻辑id的所有记录
    [self.jySceneSqlite getAllRecordFromTable:self.tableName ByArea:self.sectionName];
    
    if(self.jySceneSqlite.patterns.count == 0)
    {
        NSLog(@"刚开始进来数据库没有数据的");
        NSLog(@"走的是家居");
        //1.创建请求管理对象
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        //2.说明服务器返回的是json参数
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //3.封装请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"is_app"] = @"1";
        params[@"sceneconfig.tag"]=@"1";
        params[@"sceneconfig.room_name"] = self.sectionName;
        
        //4.发送请求
        [mgr POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/find" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             YSSceneBackStatus *backStatus = [YSSceneBackStatus statusWithDict:responseObject];
             for(int i = 0; i < backStatus.sceneArray.count; i++)
             {
                 YSScene *scene = backStatus.sceneArray[i];
                 [self.jySceneSqlite insertRecordIntoTableName:self.tableName
                                                    withField1:@"area" field1Value:scene.area
                                                     andField2:@"scene" field2Value:scene.name
                                                     andField3:@"bkgName" field3Value:scene.bkgName
                                                     andField4:@"logic_id" field4Value:scene.logic_id
                                                     andField5:@"param1" field5Value:scene.param1
                                                     andField6:@"param2" field6Value:scene.param2
                                                     andField7:@"param3" field7Value:scene.param3];
             }
             
             [self.jySceneSqlite getAllRecordFromTable:self.tableName ByArea:self.sectionName];
             
             
             self.scenes = self.jySceneSqlite.patterns;
             self.scenesOnly=self.jySceneSqlite.scenesOnly;

             //最后一个自定义按钮
             JYSceneOnly *scene = [[JYSceneOnly alloc] init];
             scene.name=@"自定义";
             [self.scenesOnly addObject:scene];
             for(int i=0;i<self.scenesOnly.count;i++)
             {
                 JYSceneOnly *scene=self.scenesOnly[i];
                 if([scene.name isEqualToString:@"观影"])
                 {
                     scene.logoName=@"guanying_icon";
                 }
                 else if([scene.name isEqualToString:@"会客"])
                 {
                     scene.logoName=@"huike_icon";
                 }
                 else if([scene.name isEqualToString:@"浪漫"])
                 {
                     scene.logoName=@"langman_icon";
                 }
                 else if([scene.name isEqualToString:@"睡眠"])
                 {
                     scene.logoName=@"shuimian_icon";
                 }
                 else if([scene.name isEqualToString:@"晚餐"])
                 {
                     scene.logoName=@"wancan_icon";
                 }
                 else if([scene.name isEqualToString:@"阅读"])
                 {
                     scene.logoName=@"yuedu_icon";
                 }
                 else if([scene.name isEqualToString:@"自定义"])
                 {
                     scene.logoName=@"zidingyi";
                 }
                 else
                 {
                     scene.logoName=@"zidingyi_icon";
                 }
            }
             for(int i=0;i<self.scenesOnly.count;i++)
             {
                 JYSceneOnly *scene=self.scenesOnly[i];
                 NSLog(@"%@ %@ %@",scene.name,scene.area,scene.bkgName);
             }
             
             for(int i = 0; i < self.scenes.count; i++)
             {
                 YSScene *scene = self.scenes[i];
                 NSLog(@"======%@ %@ %@  %@ %@ %@ %@ %@",scene.logic_id,scene.name,scene.area, scene.logoName, scene.bkgName,scene.param1,scene.param2,scene.param3);
             }
             //初始化scrollView
             [self initScrollView];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD showError:@"服务器加载数据失败"];
         }];
    }
    else
    {
        NSLog(@"数据库已经有数据");
        self.scenes = self.jySceneSqlite.patterns;
        self.scenesOnly=self.jySceneSqlite.scenesOnly;
        
        //最后一个自定义按钮
        JYSceneOnly *scene = [[JYSceneOnly alloc] init];
        scene.name=@"自定义";
        [self.scenesOnly addObject:scene];

        
        for(int i=0;i<self.scenesOnly.count;i++)
        {
            JYSceneOnly *scene=self.scenesOnly[i];
            NSLog(@"%@ %@ %@",scene.name,scene.area,scene.bkgName);
        }
        
        for(int i = 0; i < self.scenes.count;i++)
        {
            YSScene *scene = self.scenes[i];
            NSLog(@"======%@ %@ %@ %@ %@ %@",scene.logic_id,scene.name,scene.bkgName,scene.param1,scene.param2,scene.param3);
        }
        
        for(int i = 0; i < self.scenesOnly.count; i++)
        {
            JYSceneOnly *scene = self.scenesOnly[i];
            if([scene.name isEqualToString:@"观影"])
            {
                scene.logoName=@"guanying_icon";
            }
            else if([scene.name isEqualToString:@"会客"])
            {
                scene.logoName=@"huike_icon";
            }
            else if([scene.name isEqualToString:@"浪漫"])
            {
                scene.logoName=@"langman_icon";
            }
            else if([scene.name isEqualToString:@"睡眠"])
            {
                scene.logoName=@"shuimian_icon";
            }
            else if([scene.name isEqualToString:@"晚餐"])
            {
                scene.logoName=@"wancan_icon";
            }
            else if([scene.name isEqualToString:@"阅读"])
            {
                scene.logoName=@"yuedu_icon";
            }
            else if([scene.name isEqualToString:@"自定义"])
            {
                scene.logoName=@"zidingyi";
            }
            else
            {
                scene.logoName=@"zidingyi_icon";
            }
        }
        //初始化scrollView
        [self initScrollView];
    }
}

//初始化scrollView的内容
- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(self.cellWidth * (self.scenesOnly.count + 4), self.cellHeight);
    
    //清楚scrollView的子视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = 0.95f;
    
    if (!self.cellsView)
    {
        self.cellsView = [NSMutableArray array];
    }
    else
    {
        [self.cellsView removeAllObjects];
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
    for (int i = 2; i < self.scenesOnly.count + 2; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.cellWidth * i, 0, self.cellWidth, self.cellHeight)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.cellWidth - 10, self.cellWidth - 10)];
        image.image = [UIImage imageNamed:[self.scenesOnly[i-2] logoName]];
        image.tag = i - 2;
        view.tag = i - 2;
        [image setUserInteractionEnabled:YES];
        
        //添加按钮添加触摸手势
        if (i == self.scenesOnly.count + 1)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapGestureEvent:)];
            [image addGestureRecognizer:tap];
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
        }
        
        [view addSubview:image];
        [self.cellsView addObject:view];
        [self.scrollView addSubview:view];
    }
    
    //添加两个空白的块
    for (long i = self.scenesOnly.count + 2; i < self.scenesOnly.count + 4; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.cellWidth * i, 0, self.cellWidth, self.cellHeight)];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellWidth)];
        subView.backgroundColor = [UIColor clearColor];
        
        [view addSubview:subView];
        [self.scrollView addSubview:view];
    }
    
    //设置默认居中为第三个模式
    NSLog(@"开始滑动");
    [self.scrollView setContentOffset:CGPointMake(self.cellWidth * 2, 0) animated:YES];
    self.selectedIndex = 2;
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
        float destination = self.scrollView.contentOffset.x + (image.tag - self.selectedIndex) * self.cellWidth;
        self.selectedIndex = image.tag;
        [self.scrollView setUserInteractionEnabled:NO];
        [self.scrollView setContentOffset:CGPointMake(destination, 0) animated:YES];
    }
    //否则就是点击了居中的元素
    else
    {
        NSLog(@"进入添加新场景界面, 将该区域的电器传递过去");
        
        STNewSceneController *svc = [[STNewSceneController alloc] init];
        svc.furnitures = self.furnitureArray;
        svc.sectionName = self.sectionName;
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

//编辑模式事件
- (void)patternTapGestureEvent:(UIGestureRecognizer *)gr
{
    UIImageView *image = (UIImageView *)gr.self.view;
    
    //被点击的不是居中的元素，则进行滑动
    if (image.tag != self.selectedIndex)
    {
        float destination = self.scrollView.contentOffset.x + (image.tag - self.selectedIndex) * self.cellWidth;
        self.selectedIndex = image.tag;
        [self.scrollView setUserInteractionEnabled:NO];
        [self.scrollView setContentOffset:CGPointMake(destination, 0) animated:YES];
    }
    //否则就是点击了居中的元素
    else
    {
        //NSLog(@"进入编辑模式的界面");
        if (self.selectedIndex == (self.scenesOnly.count - 1))
        {
            //
        }
    }
}

//向上滑动删除
- (void)swipeToDeletePattern:(UIGestureRecognizer *)gr
{
    NSLog(@"这里进行向上滑动删除");
    UIView *view = (UIView *)gr.self.view;
    
    //想删除的不是居中的元素，或者默认模式不允许删除，或者是添加按钮键
    if (view.tag != self.selectedIndex || self.selectedIndex < DEFAULT_CELL_NUMBER || view.tag == self.scenesOnly.count - 1)
    {
        return;
    }
    
    JYSceneOnly *sceneOnly=[self.scenesOnly objectAtIndex:view.tag];
    NSLog(@"看看向上滑动的是哪个场景:%@ %@ %@ %@",sceneOnly.area,sceneOnly.name,sceneOnly.bkgName,sceneOnly.logoName);
    //从模型中删除
    [self.scenesOnly removeObjectAtIndex:view.tag];
    
    //接下来应该得到该场景下的所有电器，然后全部删除
    for(int i=0;i<self.scenes.count;i++)
    {
        YSScene *scene=self.scenes[i];
        if([scene.name isEqualToString:sceneOnly.name])
        {
             NSLog(@"呀呀呀:%@ %@ %@  %@ %@ %@ %@ %@",scene.logic_id,scene.name,scene.area, scene.logoName, scene.bkgName,scene.param1,scene.param2,scene.param3);
            [HttpRequest deleteSceneFromServer:scene.logic_id andWithSceneName:scene.name withArea:scene.area success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"看看返回的数据是啥呢？%@",str);
                
                [MBProgressHUD showSuccess:@"删除场景成功"];
                [self.cellsView[view.tag] setHidden:YES];
                
                UIView * changeView;
                for (long i = view.tag + 1; i < self.cellsView.count; i++)
                {
                    changeView = (UIView *)self.cellsView[i];
                    changeView.tag -= 1;
                    UIImageView *subImage = [[changeView subviews] lastObject];
                    subImage.tag -= 1;
                    
                    CGPoint point = changeView.center;
                    point.x -= self.cellWidth;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    [changeView setCenter:point];
                    
                    if (i == view.tag + 1)
                    {
                        [subImage setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                    }
                    else if (i == view.tag + 2)
                    {
                        [subImage setTransform:CGAffineTransformMakeScale(0.85f, 0.85f)];
                    }
                    else
                    {
                        [subImage setTransform:CGAffineTransformMakeScale(0.6f, 0.6f)];
                    }
                    
                    [UIView commitAnimations];
                }
                
                //移除该cell的视图
                [self.cellsView removeObjectAtIndex:view.tag];
                //更新scrollview的内容宽度
                self.scrollView.contentSize = CGSizeMake(self.cellWidth * (self.scenesOnly.count + 4), self.cellHeight);
                //更新背景和文字
                [self updateCellBackground:(int)view.tag];
                
                //服务器删除成功后，产出本地缓存
                [self.jySceneSqlite deleteRecordInArea:scene.area andInScene:scene.name andInLogicID:scene.logic_id inTable:self.tableName];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showError:@"删除场景失败"];
            }];
        }
    }
}

//点击开关灯按钮的响应事件
- (IBAction)switchClick:(id)sender
{
    UIButton *switchButton = (UIButton *)sender;
    
    //关灯变开灯
    if (!switchButton.tag)
    {
        switchButton.tag = 1;
        [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_unpress"] forState:UIControlStateNormal];
    }
    else
    {
        switchButton.tag = 0;
        [switchButton setBackgroundImage:[UIImage imageNamed:@"switch_icon_off"] forState:UIControlStateNormal];
    }
}

//修改背景图片的代理方法
-(void)changBG:(UIImage *)image
{
    NSLog(@"这里修改场景的背景图片");
    //为新图片创建一个标示文件名的值
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *imageName = [uuid UUIDString];
    
    //接下来存储改文件到本地，以及更新模型的数据
    YSScene *scene = self.scenesOnly[self.selectedIndex];
    scene.bkgName = imageName;
    
    [[LYSImageStore sharedStore] setImage:image forKey:imageName];
    
    //这里把该YSScene更新到数据库
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    //这里显示图片
    [self updateCellBackground:(int)self.selectedIndex];
}
//点击播放音乐的响应事件
- (IBAction)musicClick:(id)sender
{
    if (!self.musicView.tag)
    {
        //弹出音乐界面
        [UIView animateWithDuration:0.4 animations:^{
            self.musicView.frame = CGRectMake(self.musicViewFrame.origin.x, self.musicViewFrame.origin.y, self.musicViewFrame.size.width, self.musicViewFrame.size.height);
            
            self.musicBkg.frame = CGRectMake(self.musicBkgFrame.origin.x, self.musicBkgFrame.origin.y, self.musicBkgFrame.size.width, self.musicBkgFrame.size.height);
            
            self.musicNext.frame = CGRectMake(self.musicNextFrame.origin.x, self.musicNextFrame.origin.y, self.musicNextFrame.size.width, self.musicNextFrame.size.height);
            
            self.musicPre.frame = CGRectMake(self.musicPreFrame.origin.x, self.musicPreFrame.origin.y, self.musicPreFrame.size.width, self.musicPreFrame.size.height);
            
            self.musicPlay.frame = CGRectMake(self.musicPlayFrame.origin.x, self.musicPlayFrame.origin.y, self.musicPlayFrame.size.width, self.musicPlayFrame.size.height);
        }];
        
        self.musicView.tag = 1;
    }
    else
    {
        //缩回音乐界面
        float gap = self.musicButton.frame.size.width / 2;
        [UIView animateWithDuration:0.4 animations:^{
            self.musicView.frame = CGRectMake(self.musicViewFrame.origin.x + self.musicViewFrame.size.width - gap, self.musicViewFrame.origin.y, 0, self.musicViewFrame.size.height);
        }];
        self.musicView.tag = 0;
    }
    
}

- (IBAction)musicPreClick:(id)sender
{
    NSLog(@"这里是上一首");
    [HttpRequest getMusicActionfromProtol:@"power_on" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功：%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (IBAction)musicNextClick:(id)sender
{
    NSLog(@"这里是下一首");
    
    [HttpRequest getMusicActionfromProtol:@"power_off" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功：%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (IBAction)musicPlayClick:(id)sender
{
    
    UIButton *play = (UIButton *)sender;
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    
    //暂停变播放
    if (!play.tag)
    {
        NSLog(@"这里是播放");
        
        //接下来在这里写播放的代码
        [HttpRequest getMusicActionfromProtol:@"start" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"请求成功：%@",result);
            
            [userDefault setObject:@"start" forKey:@"music_state"];
            play.tag = 1;
            [self.musicPlay setBackgroundImage:[UIImage imageNamed:@"music_bofang"] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
    else
    {
        NSLog(@"这里是暂停");
        
        //接下来在这里写播放的代码
        
        [HttpRequest getMusicActionfromProtol:@"stop" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"请求成功：%@",result);
            
            [userDefault setObject:@"stop" forKey:@"music_state"];
            play.tag = 0;
            [self.musicPlay setBackgroundImage:[UIImage imageNamed:@"music_zanting"] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
}

#pragma mark - scrollView中cell的动态操作

- (void)addSceneToScrollView:(YSScene *)scene
{
    //先把该模式添加到数组中
    [self.scenesOnly insertObject:scene atIndex:self.scenesOnly.count];
    
    //然后添加到scrollView中
    //待定
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
    if (targetContentOffset->x >= (self.scenesOnly.count - 1) * self.cellWidth)
    {
        [self updateCellBackground:(int)self.scenesOnly.count - 1];
    }
    else if(targetContentOffset->x <= 0)
    {
        //变得太快了
        [self updateCellBackground:0];
        NSLog(@"这里应该要进行灯的控制了");
        JYSceneOnly *sceneOnly=self.scenesOnly[0];

        //滑动到哪个场景后，应该要得到出该场景下有哪些灯并且获取灯的参数值
        for(int i=0;i<self.scenes.count;i++)
        {
            YSScene *scene=self.scenes[i];
            //NSLog(@"%@ %@ %@ %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id,scene.param1,scene.param2,scene.param3);
            if([sceneOnly.name isEqualToString:scene.name])
            {
                //NSLog(@"找到对应场景下的灯了，开始发送请求哦");
                NSLog(@"!!!找到对应场景下的灯了：%@ %@ %@ %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id,scene.param1,scene.param2,scene.param3);
                
                //            NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param1 intValue]]];
                //            NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param2 intValue]]];
                //            NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param3 intValue]]];
                //
                //            if([scene.name isEqualToString:@"自定义"])
                //            {
                //
                //            }
                //            else
                //            {
                //                [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                //                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
                //                                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //                                                  NSLog(@"成功: %@", string);
                //
                //                                              }
                //                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //            
                //                                                  [MBProgressHUD showError:@"请检查网关"];
                //            
                //                                              }];
                //            
                //                }
                //            
            }
        }
    }
}

//滑动的时候就会调用的函数，在这里写动画？
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //处理每一个cell，计算它的缩放比例
    for (int i = 0; i < self.cellsView.count; i++)
    {
        float lead = self.cellWidth * (i + 2);
        float tail = self.cellWidth * (i + 3);
        
        //在屏幕左侧
        if (self.scrollView.contentOffset.x > tail)
        {
            [self viewToScale:0.6 target:self.cellsView[i]];
        }
        //在屏幕右侧
        else if ((self.scrollView.contentOffset.x + UISCREEN_WIDTH) < lead)
        {
            [self viewToScale:0.6 target:self.cellsView[i]];
        }
        //现在在界面上
        else
        {
            float sub = lead - self.scrollView.contentOffset.x;
            //前半部分
            if (sub <= 2 * self.cellWidth)
            {
                float rate = sub / (2 * self.cellWidth) * 0.5 + 0.6;
                rate = rate > 1.0 ? 1.0 : rate;
                [self viewToScale:rate target:self.cellsView[i]];
            }
            else
            {
                float rate = (UISCREEN_WIDTH - sub - self.cellWidth) / (2 * self.cellWidth) * 0.5 + 0.6;
                rate = rate > 1.0 ? 1.0 : rate;
                [self viewToScale:rate target:self.cellsView[i]];
            }
        }
    }
}

- (void)viewToScale:(float)scale target:(UIView *)view
{
    UIImageView *image = [[view subviews] lastObject];
    [UIView beginAnimations:@"scale" context:nil];
    image.transform = CGAffineTransformMakeScale(scale, scale);
    [UIView commitAnimations];
}

//滑动动画结束时调用的函数
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //根据居中的选项更新背景和文字
    [self updateCellBackground:(int)self.selectedIndex];
    
    [self.scrollView setUserInteractionEnabled:YES];
    NSLog(@"应该要控制灯了");
    JYSceneOnly *sceneOnly=self.scenesOnly[(int)self.selectedIndex];
    self.edit_Area=sceneOnly.area;
    self.edit_sceneName=sceneOnly.name;
    
    //滑动到哪个场景后，应该要得到出该场景下有哪些灯并且获取灯的参数值
    [self.editFurnitureArray removeAllObjects];
    
    for(int i=0;i<self.scenes.count;i++)
    {
        YSScene *scene=self.scenes[i];
        //NSLog(@"%@ %@ %@ %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id,scene.param1,scene.param2,scene.param3);
        if([sceneOnly.name isEqualToString:scene.name])
        {
            //NSLog(@"找到对应场景下的灯了，开始发送请求哦");
             NSLog(@"找到对应场景下的灯了：%@ %@ %@ %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id,scene.param1,scene.param2,scene.param3);
             [self.editFurnitureArray addObject:scene];
            
//            NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param1 intValue]]];
//            NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param2 intValue]]];
//            NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[scene.param3 intValue]]];
//            
//            if([scene.name isEqualToString:@"自定义"])
//            {
//            
//            }
//            else
//            {
//                [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
//                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//                                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                                                  NSLog(@"成功: %@", string);
//            
//                                              }
//                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//                                                  [MBProgressHUD showError:@"请检查网关"];
//            
//                                              }];
//            
//                }
//            
        }
    }
}

//计算位置，居中选中的cell
- (void)cellJumpToIndex:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x < self.cellWidth * 0.5)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (self.scrollView.contentOffset.x > self.cellWidth * (self.scenesOnly.count + 1.5))
    {
        [self.scrollView setContentOffset:CGPointMake(self.cellWidth * (self.scenesOnly.count + 1), 0) animated:YES];
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
    //NSLog(@"sleectt  %ld", (long)self.selectedIndex);
    self.patternNameLabel.text = [self.scenesOnly[index] name];
    
    //如果是添加模式按钮则不修改图片
    if (index != self.scenesOnly.count - 1)
    {
        //为默认模式，家在默认图片
        if (self.selectedIndex < DEFAULT_CELL_NUMBER)
        {
            self.bkgImageView.image = [UIImage imageNamed:[self.scenesOnly[index] bkgName]];
        }
        //自定义图片加载自定义模式
        else
        {
            YSScene * selectedScene = self.scenesOnly[self.selectedIndex];
            UIImage *image = [[LYSImageStore sharedStore] imageForKey:selectedScene.bkgName];
            
            if (!image)
            {
                self.bkgImageView.image = [UIImage imageNamed:[self.scenesOnly[index] bkgName]];
            }
            else
            {
                self.bkgImageView.image = image;
            }
        }
    }
    
}

#pragma mark - 设置导航栏的按钮
- (void)setNaviBarItemButton{
    
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:self.sectionName];
    titleView.frame = CGRectMake(0, 0, 100, 16);
    titleView.font = [UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"edit_icon_unpress"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    rightButton.tag = 1;
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightButtonClick:(id)sender
{
    NSLog(@"这里点击的是编辑吧");
    STEditSceneController *vc=[[STEditSceneController alloc]init];
    vc.area=self.edit_Area;
    vc.scene_name=self.edit_sceneName;
    vc.editFurnitureArray=[[NSMutableArray alloc]init];
    vc.editFurnitureArray=self.editFurnitureArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBtnClicked
{
   [self.navigationController popViewControllerAnimated:YES];
}
@end
