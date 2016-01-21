//
//  STUserInfoController.m
//  个人信息demo
//
//  Created by 123 on 16/1/8.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STNewSceneController.h"
#import "YSNewSceneView.h"
#import "STNewSceneCell.h"
#import "UIImage+ST.h"
#import "JYFurniture.h"
#import "YSSceneViewController.h"
#import "AFNetworking.h"
#import "JYSceneSqlite.h"
#import "YSSceneBackStatus.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"

@interface STNewSceneController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)YSNewSceneView *xinSceneView;
@property(nonatomic,strong)NSArray *iconArray;
@property(nonatomic,strong)NSArray *deviceArray;
@property(nonatomic,copy)NSString *tableName;

@end

@implementation STNewSceneController

-(NSArray *)iconArray
{
    if (_iconArray==nil) {
        NSArray *iconArr=[NSArray arrayWithObjects:@"changjing_edit_icon_yw", @"changjing_edit_icon_rgb",@"changjing_edit_icon_music",@"changjing_edit_icon_ac",nil];
        _iconArray=iconArr;
    }
    return _iconArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.tableName = [NSString stringWithFormat:@"sceneTable%@",appDelegate.user_id];
    NSLog(@"看看表明%@",self.tableName);
    
    NSLog(@"看看有区域名称:%@",self.sectionName);
    NSLog(@"看看传递过来几盏灯了");
    for(int i=0;i<self.furnitures.count;i++)
    {
        JYFurniture *furniture=self.furnitures[i];
        NSLog(@"%@ %@",furniture.descLabel,furniture.logic_id);
    }
    
    YSNewSceneView *newSceneView=[YSNewSceneView initWithNewSceneView];
    newSceneView.frame=self.view.bounds;
    
    //场景背景图片
   //[newSceneView.sceneIcon setImage:[UIImage circleImageWithName:@"zidingyi_icon" borderWith:0 borderColor:nil]];
    newSceneView.sceneIcon.image=[UIImage imageNamed:@"zidingyi_icon"];
    
    //tableView的代理
    newSceneView.devicesTableView.delegate=self;
    newSceneView.devicesTableView.dataSource=self;
    self.xinSceneView=newSceneView;
    [self.view addSubview:newSceneView];
    
    [self setNaviBarItemButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.furnitures.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"deviceCell";
    STNewSceneCell *deviceCell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取电器
    JYFurniture *furniture = self.furnitures[indexPath.row];
    
    if (deviceCell==nil)
    {
        deviceCell = [STNewSceneCell initWithNewSceneCell];
        
        //判断设备类型设置图标
        if ([furniture.deviceType isEqualToString:@"40"])
        {
            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_rgb"]];
        }
        else if ([furniture.deviceType isEqualToString:@"41"])
        {
            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_yw"]];
        }
        else
        {
            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_ac"]];
        }
     
        deviceCell.deviceName.text = furniture.descLabel;
        UIColor *color=[[UIColor alloc]initWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];
        deviceCell.selectedBackgroundView=[[UIView alloc]initWithFrame:deviceCell.frame];
        deviceCell.selectedBackgroundView.backgroundColor=color;
    }
    return deviceCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=45;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}

-(void)saveNewScene:(NSString *)sceneName
{
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    sceneName = self.xinSceneView.xinSceneName.text;
    NSLog(@"看看区域和新建场景名称:%@ %@",self.sectionName,sceneName);
    
    
    
    
//    //1.创建请求管理对象
//    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
//    
//    //2.说明服务器返回的是json参数
//    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
//    
//    //3.封装请求参数
//    NSMutableDictionary *params=[NSMutableDictionary dictionary];
//    params[@"is_app"]=@"1";
//    params[@"sceneconfig.room_name"] = self.sectionName;
//    params[@"sceneconfig.equipment_logic_id"] = ((JYFurniture *)self.furnitures[0]).logic_id;
//    params[@"sceneconfig.scene_name"] = sceneName;
//    params[@"sceneconfig.param1"] = @"110";
//    params[@"sceneconfig.param2"] = @"110";
//    params[@"sceneconfig.param3"] = @"110";
//    params[@"sceneconfig.image"]=@"rouhe_bg";
//    
//    
//    //4.发送请求
//    [mgr POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"看看返回的数据是啥呢？%@",responseObject);
//         if([responseObject[@"code"] isEqualToString:@"0"])
//         {
//             JYSceneSqlite *jySqlite=[[JYSceneSqlite alloc]init];
//             jySqlite.patterns=[[NSMutableArray alloc]init];
//             
//             //打开数据库
//             [jySqlite openDB];
//             
//             [jySqlite insertRecordIntoTableName:self.tableName
//                                                withField1:@"area" field1Value:self.sectionName
//                                                 andField2:@"scene" field2Value:sceneName
//                                                 andField3:@"bkgName" field3Value:@"rouhe_bg"
//                                                 andField4:@"logic_id" field4Value:@"110"
//                                                 andField5:@"param1" field5Value:@"110"
//                                                 andField6:@"param2" field6Value:@"110"
//                                                 andField7:@"param3" field7Value:@"110"];
//             
//             for (UIViewController *controller in self.navigationController.viewControllers)
//             {
//                 if ([controller isKindOfClass:[YSSceneViewController class]])
//                 {
//                     YSSceneViewController *vc=(YSSceneViewController *)controller;
//                     vc.tag_Back = 2;
//                     [self.navigationController popToViewController:controller animated:YES];
//                 }
//             }
//         }
//         else
//         {
//             [MBProgressHUD showError:@"增加场景失败"];
//         }
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [MBProgressHUD showError:@"增加场景失败,请检查服务器"];
//     }];
}


#pragma mark - 设置导航栏的按钮
- (void)setNaviBarItemButton{
    
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:@"新建场景"];
    titleView.frame = CGRectMake(0, 0, 100, 16);
    titleView.font = [UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(rightButtonClick:)];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightButtonClick:(id)sender
{
    [self saveNewScene:nil];
}

- (void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
