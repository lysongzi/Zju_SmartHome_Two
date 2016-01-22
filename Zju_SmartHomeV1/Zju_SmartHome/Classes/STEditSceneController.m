//
//  STUserInfoController.m
//  个人信息demo
//
//  Created by 123 on 16/1/8.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STEditSceneController.h"
#import "STEditSceneView.h"
#import "STEditSceneCell.h"
#import "UIImage+ST.h"
#import "YSScene.h"
@interface STEditSceneController ()<UITableViewDataSource,UITableViewDelegate,STEditSceneViewDelegate>
@property(nonatomic,strong)STEditSceneView *editSceneView;
@property(nonatomic,strong)NSArray *iconArray;
@property(nonatomic,strong)NSArray *deviceArray;
@end

@implementation STEditSceneController

-(NSArray *)iconArray
{
    if (_iconArray==nil) {
        NSArray *iconArr=[NSArray arrayWithObjects:@"changjing_edit_icon_yw", @"changjing_edit_icon_rgb",@"changjing_edit_icon_music",@"changjing_edit_icon_ac",nil];
        _iconArray=iconArr;
    }
    return _iconArray;
}
-(NSArray *)deviceArray
{
    if (_deviceArray==nil) {
        NSArray *deviceArr=[NSArray arrayWithObjects:@"YW灯", @"RGB灯",@"音响",@"空调",nil];
        _deviceArray=deviceArr;
    }
    return _deviceArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviBarItemButton];
    NSLog(@"看看当前场景的区域和名称有没有传递过来:%@ %@",self.area,self.scene_name);
    for(int i=0;i<self.editFurnitureArray.count;i++)
    {
        YSScene *scene=self.editFurnitureArray[i];
        NSLog(@"HHJJ:%@ %@ %@",scene.area,scene.name,scene.logic_id);
    }
    
    STEditSceneView *editSceneView=[STEditSceneView initWithEditSceneView];
    editSceneView.frame=self.view.bounds;
    
    //用户名
    editSceneView.sceneName.text=self.scene_name;
    
    //头像
    [editSceneView.sceneIcon setImage:[UIImage circleImageWithName:@"头像.jpg" borderWith:0 borderColor:nil]];
    
    //userView的代理
    editSceneView.delegate=self;
    //tableView的代理
    editSceneView.devicesTableView.delegate=self;
    editSceneView.devicesTableView.dataSource=self;
    self.editSceneView=editSceneView;
    [self.view addSubview:editSceneView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editFurnitureArray.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID=@"deviceCell";
//    STEditSceneCell *deviceCell=[tableView dequeueReusableCellWithIdentifier:ID];
//    
//    //获取电器
//    YSScene *furniture = self.editFurnitureArray[indexPath.row];
//    //furniture.isNeeded=(int)deviceCell.isNeed.tag;
//    
//    if (deviceCell==nil)
//    {
//        deviceCell = [STEditSceneCell initWithEditSceneCell];
////        
////        //判断设备类型设置图标
////        if ([furniture.deviceType isEqualToString:@"40"])
////        {
////            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_rgb"]];
////        }
////        else if ([furniture.deviceType isEqualToString:@"41"])
////        {
////            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_yw"]];
////        }
////        else
////        {
////            [deviceCell.iconView setImage:[UIImage imageNamed:@"changjing_edit_icon_ac"]];
////        }
//        
//        deviceCell.deviceName.text = furniture.;
//        UIColor *color=[[UIColor alloc]initWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];
//        deviceCell.selectedBackgroundView=[[UIView alloc]initWithFrame:deviceCell.frame];
//        deviceCell.selectedBackgroundView.backgroundColor=color;
//        
////        [deviceCell.isNeed addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
   //return deviceCell;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=45;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"=====%ld",(long)indexPath.row);
//}

#pragma mark - 设置导航栏的按钮
- (void)setNaviBarItemButton{
    
    UILabel *titleView = [[UILabel alloc]init];
    [titleView setText:@"编辑场景"];
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
//    [self saveNewScene:nil];
    NSLog(@"右边保存按钮吧？");
}

- (void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
