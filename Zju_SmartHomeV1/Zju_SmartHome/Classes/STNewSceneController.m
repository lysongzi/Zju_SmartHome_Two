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
#import "DLLampControlRGBModeViewController.h"
#import "DLLampControllYWModeViewController.h"
#import "YSScene.h"

@interface STNewSceneController ()<UITableViewDataSource,UITableViewDelegate,DLLampControlRGBModeViewDelegate
>

@property(nonatomic,strong)YSNewSceneView *xinSceneView;
@property(nonatomic,strong)NSArray *iconArray;
@property(nonatomic,strong)NSArray *deviceArray;
@property(nonatomic,copy)NSString *tableName;

@property(nonatomic,strong)NSMutableArray *uploadArray;

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
    self.uploadArray=[[NSMutableArray alloc]init];
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
    furniture.isNeeded=(int)deviceCell.isNeed.tag;

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
        
        [deviceCell.isNeed addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return deviceCell;
}
-(void)switchBtn:(id)sender
{
    UIButton *button=sender;
    
   
    
    if(button.tag==0)
    {
        button.tag=-1;
        [button setBackgroundImage:[UIImage imageNamed:@"changjing_edit_btn_equipment_notadded"] forState:UIControlStateNormal];
    }
    else if(button.tag==-1)
    {
        button.tag=0;
        [button setBackgroundImage:[UIImage imageNamed:@"changjing_edit_btn_equipment_added"] forState:UIControlStateNormal];
    }
    
    UIView *v = [sender superview];//获取父类view
    STNewSceneCell *cell = (STNewSceneCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.xinSceneView.devicesTableView indexPathForCell:cell];//获取cell对应的indexpath;
    //NSLog(@"看看点击的是哪行：%ld",indexpath.row);
    JYFurniture *furniture=self.furnitures[indexpath.row];
    furniture.isNeeded=(int)button.tag;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.xinSceneView.xinSceneName.text isEqualToString:@""])
    {
        NSLog(@"请先输入场景名称");
    }
    else
    {
        JYFurniture *furniture=self.furnitures[indexPath.row];
        if(furniture.isNeeded==-1)
        {
            NSLog(@"说明此灯没选中");
        }
        else if(furniture.isNeeded==0)
        {
            //说明是RGB灯
            if([furniture.deviceType isEqualToString:@"40"])
            {
                NSLog(@"跳转到RGB自定义颜色界面");
                DLLampControlRGBModeViewController *vc=[[DLLampControlRGBModeViewController alloc]init];
                vc.sceneTag=40;
                vc.delegate=self;
                vc.logic_id=furniture.logic_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
            //说明是YW灯
            else if([furniture.deviceType isEqualToString:@"41"])
            {
                NSLog(@"跳转到YW灯自定义颜色界面");
                DLLampControllYWModeViewController *vc=[[DLLampControllYWModeViewController alloc]init];
                vc.sceneTag=41;
                vc.logic_id=furniture.logic_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
            //说明是其他
            else
            {
                
            }
        }
    }
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
   // NSLog(@"看看区域和新建场景名称:%@ %@",self.sectionName,sceneName);
    
//    for(int i=0;i<self.furnitures.count;i++)
//    {
//        JYFurniture *furniture=self.furnitures[i];
//        NSLog(@"jjj %d",furniture.isNeeded);
//    }
    int i=0;
    for(i=0;i<self.uploadArray.count;i++)
    {
        YSScene *scene=self.uploadArray[i];
//        NSLog(@"??? %@ %@ %@ %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id, scene.param1,scene.param2,scene.param3);
        //1.创建请求管理对象
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        
        //2.说明服务器返回的是json参数
        mgr.responseSerializer=[AFJSONResponseSerializer serializer];
        
        //3.封装请求参数
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        //移动端
        params[@"is_app"]=@"1";
        //标志场景
        params[@"sceneconfig.tag"]=@"1";
        //区域
        params[@"sceneconfig.room_name"] = scene.area;
        //场景名称
        params[@"sceneconfig.scene_name"] = scene.name;
        //场景背景图
        params[@"sceneconfig.image"]=scene.bkgName;
        //电器逻辑id
        params[@"sceneconfig.equipment_logic_id"]=scene.logic_id;
        //参数值
        params[@"sceneconfig.param1"] = scene.param1;
        params[@"sceneconfig.param2"] = scene.param2;
        params[@"sceneconfig.param3"] = scene.param3;
        
        NSLog(@"1111 %@ %@ %@ %@",scene.area,scene.name,scene.bkgName,scene.logic_id);
        
        //4.发送请求
        [mgr POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"看看返回的数据是啥呢？%@",responseObject);
             NSLog(@"%@",responseObject[@"msg"]);
             if([responseObject[@"code"] isEqualToString:@"0"])
             {
                 JYSceneSqlite *jySqlite=[[JYSceneSqlite alloc]init];
                 jySqlite.patterns=[[NSMutableArray alloc]init];
                 
                 //打开数据库
                 [jySqlite openDB];
                 
                 [jySqlite insertRecordIntoTableName:self.tableName
                                          withField1:@"area" field1Value:scene.area
                                           andField2:@"scene" field2Value:scene.name
                                           andField3:@"bkgName" field3Value:scene.bkgName
                                           andField4:@"logic_id" field4Value:scene.logic_id
                                           andField5:@"param1" field5Value:scene.param1
                                           andField6:@"param2" field6Value:scene.param2
                                           andField7:@"param3" field7Value:scene.param3];
                 
             }
             else
             {
                 [MBProgressHUD showError:@"增加场景失败"];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD showError:@"增加场景失败,请检查服务器"];
         }];
    }
    if(i>=self.uploadArray.count)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[YSSceneViewController class]])
            {
                YSSceneViewController *vc=(YSSceneViewController *)controller;
                vc.tag_Back = 2;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
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

//实现代理
-(void)backParam:(NSString *)param1 andParam2:(NSString *)param2 andParam3:(NSString *)param3 andLogic_Id:(NSString *)logic_id
{
   NSLog(@"123 %@ %@ %@ %@ %@ %@",self.sectionName, self.xinSceneView.xinSceneName.text, param1,param2,param3,logic_id);
    
    YSScene *scene=[[YSScene alloc]init];
    scene.area=self.sectionName;
    scene.name=self.xinSceneView.xinSceneName.text;
    scene.bkgName=@"guanying";
    scene.logic_id=logic_id;
    scene.param1=param1;
    scene.param2=param2;
    scene.param3=param3;
    
    
    int i=0;
    for(i=0;i<self.uploadArray.count;i++)
    {
        YSScene *scene1=self.uploadArray[i];
        if([scene1.logic_id isEqualToString:logic_id])
        {
            self.uploadArray[i]=scene;
            break;
        }
    }
    if(i>=self.uploadArray.count)
    {
        [self.uploadArray addObject:scene];
    }
}
@end
