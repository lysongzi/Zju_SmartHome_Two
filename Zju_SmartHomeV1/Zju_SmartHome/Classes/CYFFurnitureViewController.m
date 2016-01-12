//
//  CYFFurnitureViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#import "JYFurniture.h"
#import "JYFurnitureSection.h"
#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#import "JYFurniture.h"
#import "JYFurnitureSection.h"
#import "QRCatchViewController.h"
//#import "DLAddDeviceView.h"
#import "STAddDeviceView.h"
#import "JYFurnitureBack.h"
#import "AFNetworking.h"
#import "JYFurnitureBackStatus.h"
#import "DLLampControlGuestModeViewController.h"

#import "HttpRequest.h"
#import "Constants.h"
#import "LogicIdXMLParser.h"
#import "UIKit/UIKit.h"
#import "CYFYWControllerViewController.h"
#import "JYOtherViewController.h"
#import "MBProgressHUD+MJ.h"
#import "DLLampControllYWModeViewController.h"
#import "CYFMainViewController.h"
#import "JYUpdateFurnitureName.h"
#import "YSRGBPatternViewController.h"
#import "YSYWPatternViewController.h"
#import "YSSceneViewController.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define GAP_WIDTH 36
#define GAP_HEIGHT 12
#define SECTION_COLUMN 3

NS_ENUM(NSInteger, ProviderEditingState)
{
  ProviderEditStateNormal,
  ProviderEditStateDelete
};

@interface CYFFurnitureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,STAddDeviceDelegate,UINavigationBarDelegate,JYUpdateFurnitureNameDelegate>

//collectionView属性
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//增加智能区域
- (IBAction)add:(id)sender;

//智能区域数组
@property(nonatomic,strong)NSMutableArray *furnitureSecArray;

//某一区域电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;

//添加电器View
@property(nonatomic,strong)STAddDeviceView *addDeviceView;
//更改电器名称View
@property(nonatomic,strong)JYUpdateFurnitureName *updateFurniture;

//头部数组
@property(nonatomic,strong)NSMutableArray *headerArray;
//默认图片数组
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *imageHighArray;
//默认文字描述
@property(nonatomic,strong)NSMutableArray *descArray;

@property(nonatomic,strong)JYFurnitureBackStatus *furnitureBackStatus;


@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *addFurnitureButton;

@property (assign) enum ProviderEditingState currentEditState;

//添加区域按钮
@property (weak, nonatomic) IBOutlet UIButton *addArea;
@property(nonatomic,assign)int tag;

@property(nonatomic,assign)NSInteger updateSecion;
@property(nonatomic,assign)NSInteger updateRow;
@end

@implementation CYFFurnitureViewController

- (NSMutableArray *)headerArray
{
  if(!_headerArray)
  {
    _headerArray = [[NSMutableArray alloc] initWithObjects:@"客厅",@"卧室", nil];
  }
  return _headerArray;
}

- (NSMutableArray *)imageArray
{
    if(!_imageArray)
    {
//    _imageArray=[[NSMutableArray alloc]initWithObjects:@"single_btn_ac_off",@"single_btn_fridge_off",@"single_btn_tv_off",@"single_btn_rgb_on",@"single_btn_yw_off",@"equipment_add" ,nil];
      _imageArray = [[NSMutableArray alloc]initWithObjects:@"single_btn_fridge_off",@"single_btn_music_off",@"single_btn_tv_off",@"single_btn_rgb_off",@"single_btn_yw_off",@"single_btn_add" ,nil];
    }
    return _imageArray;
}

- (NSMutableArray *)imageHighArray
{
    if(!_imageHighArray)
    {
        _imageHighArray = [[NSMutableArray alloc]initWithObjects:@"single_btn_fridge_on",@"single_btn_music_on",@"single_btn_tv_on",@"single_btn_rgb_on",@"single_btn_yw_on",@"single_btn_add" ,nil];
    }
    return _imageHighArray;
}

- (NSMutableArray *)descArray
{
    if(!_descArray)
    {
        _descArray = [[NSMutableArray alloc]initWithObjects:@"空调",@"音响",@"电视",@"RGB灯",@"YW灯",@"添加", nil];
    }
    return _descArray;
}

- (NSMutableArray *)furnitureSecArray
{
    if(!_furnitureSecArray)
    {
        _furnitureSecArray = [[NSMutableArray alloc]init];
        //默认有两个智能区域
        for(int i = 0; i < 2; i++)
        {
            _furnitureArray = [[NSMutableArray alloc]init];
            //每个区域默认有5个电器和一个添加电器图片
            for(int j = 0; j < 6; j++)
            {
                //初始化一个电器
                JYFurniture *furniture = [[JYFurniture alloc]init];
                //设置电器图片
                furniture.imageStr = self.imageArray[j];
                //设置电器描述文字
                furniture.descLabel = self.descArray[j];
                //设置电器是否注册过
                furniture.registed = NO;
                //设置电器类型为空
                furniture.deviceType = @"";
                furniture.controller = nil;
        
                //将电器添加到电器数组中
                [_furnitureArray addObject:furniture];
            }
      
            //初始化一个智能区域
            JYFurnitureSection *furnitureSection = [[JYFurnitureSection alloc]init];
            //设置智能区域的名称
            furnitureSection.sectionName = self.headerArray[i];
            //设置智能区域的电器数组
            furnitureSection.furnitureArray = _furnitureArray;
            //将智能区域添加到智能区域数组中
            [_furnitureSecArray addObject:furnitureSection];
        }
    }
    return _furnitureSecArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //进行CollectionView和Cell的绑定
    [self.collectionView registerClass:[CYFCollectionViewCell class]  forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.backgroundColor = [UIColor blackColor];
  
    //加入头部视图；
    [self.collectionView registerClass:[CYFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
  
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //右侧滚动条隐藏
    self.collectionView.showsVerticalScrollIndicator=false;
  
    //获取服务器数据
    [self getDataFromReote];
  
    //长按cell的方法；
    [self addLongPressGestureToCell];
  
    //设置Navi的NaviBarItemButton；
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

    //扫描Mac值成功，传递过来Mac值，不为空，所以弹出增加设备的提示框；
    if (self.macFromQRCatcher != nil)
    {
        [self addNewFurniture];
        self.macFromQRCatcher = nil;
    }
}

//有多少个section；
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  //有多少个一维数组；
  return self.furnitureSecArray.count;
}

//加载头部标题；
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
  
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    view.title.text=furnitureSection.sectionName;
    view.tag = indexPath.section;
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (void)headerTap:(UITapGestureRecognizer *)gr
{
    CYFCollectionReusableView *view = (CYFCollectionReusableView *)gr.view;
    NSInteger tag = view.tag;
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:tag];
    
    YSSceneViewController *svc = [[YSSceneViewController alloc] init];
    svc.sectionName = furnitureSection.sectionName;
    svc.furnitureArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<self.furnitureSecArray.count;i++)
    {
        JYFurnitureSection *section=self.furnitureSecArray[i];
        if([view.title.text isEqualToString:section.sectionName])
        {
            NSLog(@"看看点中的是哪个头部%@",section.sectionName);
            for(int j=0;j<section.furnitureArray.count;j++)
            {
                JYFurniture *furniture=section.furnitureArray[j];
                //将某区域下注册的电器传递过去
                if(furniture.registed==YES)
                {
                    [svc.furnitureArray addObject:furniture];
                }
            }
        }
    }
    [self.navigationController pushViewController:svc animated:YES];
}

//每一部分有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    JYFurnitureSection *furnitureSction=[self.furnitureSecArray objectAtIndex:section];
    return furnitureSction.furnitureArray.count;
}

//每一个item具体显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell"
                                                                          forIndexPath:indexPath];
  
    JYFurnitureSection *furnitureSection = [self.furnitureSecArray objectAtIndex:indexPath.section];
    JYFurniture *furniture = [furnitureSection.furnitureArray objectAtIndex:indexPath.row];
  
    cell.imageButton.image = [UIImage imageNamed:furniture.imageStr];
    cell.descLabel.text = furniture.descLabel;
    
    if (!furniture.registed)
    {
        cell.lightImage.hidden = YES;
    }
    else
    {
        cell.lightImage.hidden = NO;
    }
    
    //在这里设置ScrollView的高度
    self.mainScrollView.contentSize = CGSizeMake(UISCREEN_WIDTH, self.mainImageView.frame.size.height + self.collectionView.contentSize.height + self.addFurnitureButton.frame.size.height + 10);
    
    float gap = GAP_WIDTH * (UISCREEN_WIDTH / 320);
    self.collectionView.frame = CGRectMake((int)gap / 2, self.mainImageView.frame.size.height + GAP_HEIGHT, UISCREEN_WIDTH - (int)gap, self.collectionView.contentSize.height + GAP_HEIGHT);
    
    //设置close按钮
    // 点击编辑按钮触发事件
    if(self.currentEditState == ProviderEditStateNormal)
    {
        //正常情况下，所有删除按钮都隐藏；
        cell.closeButton.hidden = YES;
    }
    else
    {
        //编辑情况下：
        JYFurnitureSection *section = self.furnitureSecArray[indexPath.section];
        if (indexPath.row != section.furnitureArray.count - 1)
        {
            cell.closeButton.hidden = NO;
        }
        else
        {
            //最后一个是添加按钮，所以隐藏右上角的删除按钮；
            cell.closeButton.hidden = YES;
        }
    }
    
    //每个cell添加一个删除按钮点击事件
    [cell.closeButton addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//***********************************************************************************
//下面这几个代理方法是必须实现的
//设置每一个item的宽度，高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float gap = GAP_WIDTH * (UISCREEN_WIDTH / 320);
    return CGSizeMake((UISCREEN_WIDTH - (int)gap) / SECTION_COLUMN, (UISCREEN_WIDTH - (int)gap) / SECTION_COLUMN);
}

//设置间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置section的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    float height = 42 * (UISCREEN_WIDTH / 320);
    return CGSizeMake(self.collectionView.frame.size.width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//************************************************************************************
//item点击触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JYFurnitureSection *furnitureSection = [self.furnitureSecArray objectAtIndex:indexPath.section];
  
    //点击的添加按钮
    if(indexPath.row == furnitureSection.furnitureArray.count - 1)
    {
        //获取区域
        JYFurnitureSection *section = self.furnitureSecArray[indexPath.section];
        self.area = furnitureSection.sectionName;
        self.section = section;
        self.row = indexPath.row;
        self.section1 = indexPath.section;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示 " message:@"请选择注册方式" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"手动输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            [self addNewFurniture];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            QRCatchViewController *qrCatcherVC = [[QRCatchViewController alloc]init];
            qrCatcherVC.tag = 0;
            qrCatcherVC.area = self.area;
            qrCatcherVC.section1 = self.section1;
            qrCatcherVC.row = self.row;
            qrCatcherVC.section = self.section;
            [self.navigationController pushViewController:qrCatcherVC animated:YES];
        }]];
    
        [self presentViewController:alertController animated:true completion:nil];
    }
    else
    {
        JYFurnitureSection *section = self.furnitureSecArray[indexPath.section];
        JYFurniture *furniture = section.furnitureArray[indexPath.row];
        self.area = furnitureSection.sectionName;
        self.row = [indexPath row];
        self.section1 = indexPath.section;

        if(furniture.registed == YES)
        {
            //设备为RGB灯，则进入RGB控制界面
            if([furniture.deviceType isEqualToString:@"40"])
            {
               
//                DLLampControlGuestModeViewController *dlVc = (DLLampControlGuestModeViewController *)furniture.controller;
//                NSLog(@"%@",dlVc);
//                dlVc.logic_id = furniture.logic_id;
                YSRGBPatternViewController *vc=(YSRGBPatternViewController *)furniture.controller;
                vc.logic_id=furniture.logic_id;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            //设备为YW灯，则进入YW控制界面
            else if([furniture.deviceType isEqualToString:@"41"])
            {
//                DLLampControllYWModeViewController *cyfVc = (DLLampControllYWModeViewController *)furniture.controller;
                //cyfVc.logic_id=furniture.logic_id;
                YSYWPatternViewController *vc=(YSYWPatternViewController *)furniture.controller;
                vc.logic_id=furniture.logic_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                JYOtherViewController *jyVc = (JYOtherViewController *)furniture.controller;
                jyVc.logic_id = furniture.logic_id;
                [self.navigationController pushViewController:jyVc animated:YES];
            }
        }
        else
        {
            //创建一个弹出窗口，提示先注册电器
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示 "
                                                                                     message:@"请您先注册电器"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //添加取消按钮
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}]];
            
            //添加确定按钮
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                //创建一个弹出窗口，注册电器
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示 " message:@"请选择注册方式" preferredStyle:UIAlertControllerStyleAlert];
                
                //手动输入
                [alertController addAction:[UIAlertAction actionWithTitle:@"手动输入"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action)
                {
                    //跳出填写MAC值的对话框；
                    STAddDeviceView *addDeviceView = [STAddDeviceView addDeviceView];
                    addDeviceView.delegate = self;
                    self.addDeviceView = addDeviceView;
                    addDeviceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                    //弹窗动画
                    [UIView animateWithDuration:0.5 animations:^{
                        [addDeviceView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                        
                    }completion:^(BOOL finished) {
                        self.navigationController.navigationBar.hidden=YES;
                    }];
                    
                    if(self.row < 5)
                    {
                        [addDeviceView.customName setText:self.descArray[self.row]];
                        addDeviceView.customName.textColor = [UIColor grayColor];
                        addDeviceView.customName.enabled = NO;
                    }
                    [self.view addSubview:addDeviceView];
                    self.navigationItem.hidesBackButton=YES;
                }]];//手动输入
                
                //扫码
                [alertController addAction:[UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                {
                    QRCatchViewController *qrCatcherVC=[[QRCatchViewController alloc]init];
                    qrCatcherVC.area = self.area;
                    qrCatcherVC.section1 = self.section1;
                    qrCatcherVC.row = self.row;
                    qrCatcherVC.section = self.section;
                    [self.navigationController pushViewController:qrCatcherVC animated:YES];
                }]];//扫码
        
                //显示注册电器弹出窗口
                [self presentViewController:alertController animated:true completion:nil];
            }]];
            
            //显示提示先注册电器弹出窗口
            [self presentViewController:alertController animated:true completion:nil];
        }
    }
}


- (IBAction)add:(id)sender
{
    self.furnitureArray = [[NSMutableArray alloc]init];
    
    //每个区域默认有5个电器和一个添加电器图片
    for(int i = 0; i < 6; i++)
    {
        //初始化一个电器
        JYFurniture *furniture = [[JYFurniture alloc]init];
        //设置电器图片
        furniture.imageStr = self.imageArray[i];
        //设置电器描述文字
        furniture.descLabel = self.descArray[i];
        //设置电器是否注册过
        furniture.registed = NO;
        //设置电器类型为空
        furniture.deviceType = @"";
        furniture.controller = nil;
    
        //将电器添加到电器数组中
        [self.furnitureArray addObject:furniture];
    }
    
    [self popEnvirnmentNameDialog];
}

- (void)popEnvirnmentNameDialog
{
    //初始化一个智能区域
    JYFurnitureSection *furnitureSection = [[JYFurnitureSection alloc]init];
  
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入智能区域名称" preferredStyle:UIAlertControllerStyleAlert];
  
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
  
    //以下方法就可以实现在提示框中输入文本；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
    {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
                                
        //设置智能区域的名称
        furnitureSection.sectionName = envirnmentNameTextField.text;
        //设置智能区域的电器数组
        furnitureSection.furnitureArray = self.furnitureArray;
        //将智能区域添加到智能区域数组中
        [self.furnitureSecArray addObject:furnitureSection];
                                
        //此时更新界面；
        [self.collectionView reloadData];
     }]];
  
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"请输入智能区域名称";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)addNewFurniture
{
    STAddDeviceView *addDeviceView=[STAddDeviceView addDeviceView];
    addDeviceView.mac.text = self.macFromQRCatcher;
  
    if (![addDeviceView.mac.text isEqualToString:@""])
    {
        if(self.row < 5)
        {
            addDeviceView.customName.text = self.descArray[self.row];
            addDeviceView.customName.enabled = false;
        }
    }
  
    addDeviceView.delegate = self;
  
    self.addDeviceView = addDeviceView;
    addDeviceView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        [addDeviceView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }completion:^(BOOL finished) {
        self.navigationController.navigationBar.hidden=YES;
    }];
    [self.view addSubview:addDeviceView];
    self.navigationItem.hidesBackButton=YES;
    
}

//取消添加设备
-(void)cancel
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.addDeviceView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.addDeviceView removeFromSuperview];
        self.navigationController.navigationBar.hidden=NO;
    }];
}

//添加设备
-(void)next:(NSString *)deviceName and:(NSString *)deviceMac
{
    if([deviceMac isEqualToString:@""])
    {
        [MBProgressHUD showError:@"Mac值不能为空"];
    }
    else
    {
        [HttpRequest getLogicIdfromMac:deviceMac success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [MBProgressHUD hideHUD];
             //表示从网关返回逻辑ID成功；需要解析这个逻辑ID，并发送到服务器；
             NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             //这里需要进行XML解析；
             LogicIdXMLParser *logicIdXMLParser = [[LogicIdXMLParser alloc] initWithXMLString:result];
             
             //成功接收；
             
             if([logicIdXMLParser.result isEqualToString:@"fail"])
             {
                 //NSLog(@"注册电器失败");
                 [MBProgressHUD showError:@"设备注册失败"];
             }
             else
             {
                 //开始向服务器注册该电器；
                 [HttpRequest registerDeviceToServer:logicIdXMLParser.logicId deviceName:deviceName sectionName:self.area type:logicIdXMLParser.deviceType success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
                     [self.addDeviceView removeFromSuperview];
                     
                     if(self.row < 5)
                     {
                         JYFurnitureSection *section = self.furnitureSecArray[self.section1];
                         JYFurniture *furniture = section.furnitureArray[self.row];
                         
                         furniture.imageStr = self.imageHighArray[self.row];
                         furniture.registed = YES;
                         furniture.logic_id = logicIdXMLParser.logicId;
                         furniture.deviceType = logicIdXMLParser.deviceType;
                         
                         if([furniture.deviceType isEqualToString:@"40"])
                         {

                             YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                             vc.logic_id=furniture.logic_id;
                             vc.furnitureName=furniture.descLabel;
                             furniture.controller=vc;
                         }
                         else if([furniture.deviceType isEqualToString:@"41"])
                         {
                             furniture.controller = [[DLLampControllYWModeViewController alloc]init];
                         }
                         else
                         {
                             furniture.controller = [[JYOtherViewController alloc]init];
                         }
                     }
                     else
                     {
                         JYFurniture *furniture = [[JYFurniture alloc]init];
                         furniture.descLabel = deviceName;
                         furniture.registed = YES;
                         furniture.logic_id = logicIdXMLParser.logicId;
                         furniture.deviceType = logicIdXMLParser.deviceType;
                         
                         
                         if([furniture.deviceType isEqualToString:@"40"])
                         {
                             furniture.imageStr = self.imageHighArray[3];
                             
                             YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                             vc.logic_id=furniture.logic_id;
                             vc.furnitureName=furniture.descLabel;
                             furniture.controller = vc;
                         }
                         else if([furniture.deviceType isEqualToString:@"41"])
                         {
                             furniture.imageStr = self.imageHighArray[4];
                             YSYWPatternViewController *vc=[[YSYWPatternViewController alloc]init];
                             vc.logic_id=furniture.logic_id;
                             vc.furnitureName=furniture.descLabel;
                             furniture.controller=vc;

                         }
                         else
                         {
                             furniture.imageStr = @"办公室";
                             furniture.controller = [[JYOtherViewController alloc]init];
                         }
                         
                         if(![self.addDeviceView.mac.text isEqualToString:@""])
                         {
                             JYFurnitureSection *section = self.furnitureSecArray[self.section1];
                             JYFurniture *furniture1 = section.furnitureArray[self.row];
                             furniture1 = furniture;
                             JYFurniture *temp = [section.furnitureArray lastObject];
                             [section.furnitureArray removeLastObject];
                             [section.furnitureArray addObject:furniture1];
                             [section.furnitureArray addObject:temp];
                         }
                         else
                         {
                             JYFurniture *temp = [self.section.furnitureArray lastObject];
                             [self.section.furnitureArray removeLastObject];
                             [self.section.furnitureArray addObject:furniture];
                             [self.section.furnitureArray addObject:temp];
                         }
                     }
                    self.navigationController.navigationBar.hidden=NO;
                     [self.collectionView reloadData];
                      [MBProgressHUD showSuccess:@"设备注册成功"];

                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                  {
                      [MBProgressHUD hideHUD];
                      [MBProgressHUD showError:@"设备注册失败"];
                       self.navigationController.navigationBar.hidden=NO;
                  }];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //从网关返回逻辑ID失败；
             [MBProgressHUD showError:@"获取逻辑ID失败，请检查网关"];
              self.navigationController.navigationBar.hidden=NO;
         }];
    }
}

-(void)getDataFromReote
{
    
    [HttpRequest findAllDeviceFromServer:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"9999999999%@",responseObject);
        //请求成功
        JYFurnitureBackStatus *furnitureBackStatus=[JYFurnitureBackStatus statusWithDict:responseObject];
        self.furnitureBackStatus=furnitureBackStatus;
        [self judge];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //失败的回调；
        [MBProgressHUD showError:@"服务器加载数据失败"];
    }];
}

-(void)judge
{
    NSLog(@"judge");
    //遍历从服务器返回的电器的所属区域
    for(int i = 0; i < self.furnitureBackStatus.furnitureArray.count; i++)
    {
        //按顺序取出从服务器返回的电器
        JYFurnitureBack *furnitureBack = self.furnitureBackStatus.furnitureArray[i];
        //遍历头部区域数组
        int j = 0;
        for(j = 0; j < self.headerArray.count; j++)
        {
            //如果电器的所属区域已存在于头部区域数组
            if ([furnitureBack.scene_name isEqualToString:self.headerArray[j]])
            {
                int k = 0;
                //遍历电器描述文字
                for(k = 0; k < self.descArray.count; k++)
                {
                    //如果从服务器返回的电器与已有电器描述一致
                    if([furnitureBack.name isEqualToString:self.descArray[k]])
                    {
                        //那就从self.furnitureSecArray中找到它
                        JYFurnitureSection *section = [self.furnitureSecArray objectAtIndex:j];
                        JYFurniture *furniture = [section.furnitureArray objectAtIndex:k];
                        //并将该电器的显示图片改为高亮
                        furniture.imageStr = self.imageHighArray[k];
                        furniture.registed = YES;
                        furniture.logic_id = furnitureBack.logic_id;
                        furniture.deviceType = furnitureBack.deviceType;
            
                        if([furniture.deviceType isEqualToString:@"40"])
                        {
                            YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                            vc.logic_id=furniture.logic_id;
                            vc.furnitureName=furniture.descLabel;
                            furniture.controller=vc;
                        }
                        else if([furniture.deviceType isEqualToString:@"41"])
                        {
                            //furniture.controller = [[DLLampControllYWModeViewController alloc]init];
                            YSYWPatternViewController *vc=[[YSYWPatternViewController alloc]init];
                            vc.logic_id=furniture.logic_id;
                            vc.furnitureName=furniture.descLabel;
                            furniture.controller=vc;
                            
                        }
                        else
                        {
                            furniture.controller = [[JYOtherViewController alloc]init];
                        }
                        break;
                    }
                }
                if(k >= self.descArray.count)
                {
                    //那就说明该电器不在默认电器里面，创建它
                    JYFurniture *furniture=[[JYFurniture alloc]init];
                    //furniture.imageStr=@"办公室";
                    furniture.descLabel=furnitureBack.name;
                    furniture.registed=YES;
                    furniture.logic_id=furnitureBack.logic_id;
                    furniture.deviceType=furnitureBack.deviceType;
            
                    if([furniture.deviceType isEqualToString:@"40"])
                    {
                        furniture.imageStr = self.imageHighArray[3];
                        YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                        vc.logic_id=furniture.logic_id;
                        vc.furnitureName=furniture.descLabel;
                        furniture.controller=vc;
                    }
                    else if([furniture.deviceType isEqualToString:@"41"])
                    {
                        furniture.imageStr=self.imageHighArray[4];
                        YSYWPatternViewController *vc=[[YSYWPatternViewController alloc]init];
                        vc.logic_id=furniture.logic_id;
                        vc.furnitureName=furniture.descLabel;
                        furniture.controller=vc;

                    }
                    else
                    {
                        furniture.imageStr=@"单品";
                        furniture.controller=[[JYOtherViewController alloc]init];
                    }
          
                    JYFurnitureSection *section=[self.furnitureSecArray objectAtIndex:j];
          
                    JYFurniture *temp=[[JYFurniture alloc]init];
                    temp=[section.furnitureArray lastObject];
                    [section.furnitureArray removeLastObject];
          
                    //将创建的加入
                    [section.furnitureArray addObject:furniture];
                    //将添加按钮加入
                    [section.furnitureArray addObject:temp];
                }
                break;
            }
        }
        //电器的所属区域不存在于已有头部电器数组
        if(j>=self.headerArray.count)
        {
           
            NSLog(@"---%@",furnitureBack.scene_name);
            if([furnitureBack.scene_name isEqualToString:@"-1"])
            {
                 NSLog(@"12345678900000");
            }
            else
            {
                //创建新区域
                self.furnitureArray=[[NSMutableArray alloc]init];
                //每个区域默认有5个电器和一个添加电器图片
                for(int i=0;i<6;i++)
                {
                    //初始化一个电器
                    JYFurniture *furniture=[[JYFurniture alloc]init];
                    //设置电器图片
                    furniture.imageStr=self.imageArray[i];
                    //设置电器描述文字
                    furniture.descLabel=self.descArray[i];
                    //设置电器是否注册过
                    furniture.registed=NO;
                    furniture.deviceType=@"";
                    furniture.controller=nil;
                    
                    //将电器添加到电器数组中
                    [self.furnitureArray addObject:furniture];
                }
                
                
                JYFurniture *furniture=[[JYFurniture alloc]init];
                furniture.descLabel=furnitureBack.name;
                furniture.registed=YES;
                furniture.logic_id=furnitureBack.logic_id;
                furniture.deviceType=furnitureBack.deviceType;
                
                if([furniture.deviceType isEqualToString:@"40"])
                {
                    furniture.imageStr=self.imageHighArray[3];
                    //furniture.controller=[[DLLampControlGuestModeViewController alloc]init];
                    YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                    vc.logic_id=furniture.logic_id;
                    vc.furnitureName=furniture.descLabel;
                    furniture.controller=vc;
                }
                else if([furniture.deviceType isEqualToString:@"41"])
                {
                    furniture.imageStr=self.imageHighArray[4];
                    // furniture.controller=[[DLLampControllYWModeViewController alloc]init];
                    YSYWPatternViewController *vc=[[YSYWPatternViewController alloc]init];
                    vc.logic_id=furniture.logic_id;
                    vc.furnitureName=furniture.descLabel;
                    furniture.controller=vc;
                    
                }
                else
                {
                    furniture.imageStr=@"单品";
                    furniture.controller=[[JYOtherViewController alloc]init];
                }
                
                int m=0;
                for(m=0;m<self.descArray.count;m++)
                {
                    if([furniture.descLabel isEqualToString:self.descArray[m]]){ break; }
                }
                
                if(m>=self.descArray.count)
                {
                    JYFurniture *temp=[[JYFurniture alloc]init];
                    temp=[self.furnitureArray lastObject];
                    [self.furnitureArray removeLastObject];
                    
                    [self.furnitureArray addObject:furniture];
                    [self.furnitureArray addObject:temp];
                    
                    //初始化一个智能区域
                    JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
                    //设置智能区域的名称
                    furnitureSection.sectionName=furnitureBack.scene_name;
                    //设置智能区域的电器数组
                    furnitureSection.furnitureArray=self.furnitureArray;
                    //将智能区域添加到智能区域数组中
                    [self.furnitureSecArray addObject:furnitureSection];
                    [self.headerArray addObject:furnitureBack.scene_name];
                    
                    
                    //这里判断是否有注册的电器是默认图片的
                    int k=0;
                    //遍历电器描述文字
                    for(k=0;k<self.descArray.count;k++)
                    {
                        //如果从服务器返回的电器与已有电器描述一致
                        if([furnitureBack.name isEqualToString:self.descArray[k]])
                        {
                            //那就从self.furnitureSecArray中找到它
                            JYFurnitureSection *section=[self.furnitureSecArray objectAtIndex:j];
                            JYFurniture *furniture=[section.furnitureArray objectAtIndex:k];
                            //并将该电器的显示图片改为高亮
                            furniture.imageStr=self.imageHighArray[k];
                            furniture.registed=YES;
                            furniture.logic_id=furnitureBack.logic_id;
                            furniture.deviceType=furnitureBack.deviceType;
                            if([furniture.deviceType isEqualToString:@"40"])
                            {
                                YSRGBPatternViewController *vc=[[YSRGBPatternViewController alloc]init];
                                vc.logic_id=furniture.logic_id;
                                vc.furnitureName=furniture.descLabel;
                                furniture.controller=vc;
                                //furniture.controller=[[DLLampControlGuestModeViewController alloc]init];
                            }
                            else if([furniture.deviceType isEqualToString:@"41"])
                            {
                                YSYWPatternViewController *vc=[[YSYWPatternViewController alloc]init];
                                vc.logic_id=furniture.logic_id;
                                vc.furnitureName=furniture.descLabel;
                                furniture.controller=vc;
                                // furniture.controller=[[DLLampControllYWModeViewController alloc]init];
                            }
                            else
                            {
                                furniture.controller=[[JYOtherViewController alloc]init];
                            }
                            break;
                        }
                    }
                }
                
            }
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 创建长按cell的手势
- (void)addLongPressGestureToCell
{
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
}

- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
  
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        self.updateSecion=indexPath.section;
        self.updateRow=indexPath.row;
      
        JYFurnitureSection *section=self.furnitureSecArray[self.updateSecion];
        JYFurniture *furniture1=section.furnitureArray[self.updateRow];
        
        //如果点击的是添加按钮，不做处理
        if(self.updateRow ==(section.furnitureArray.count-1)){}
        //如果row<5，说明是默认电器，不允许修改
        else if(self.updateRow<5)
        {
            if(furniture1.registed==YES)
            {
                JYUpdateFurnitureName *updateFurniture=[JYUpdateFurnitureName updateFurnitureNameView];
                updateFurniture.delegate=self;
                updateFurniture.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                self.updateFurniture=updateFurniture;
                self.updateFurniture.furnitureName.text=furniture1.descLabel;
                //self.updateFurniture.furnitureName.enabled=NO;
                [self.view addSubview:self.updateFurniture];
            }
        }
        else
        {
            JYUpdateFurnitureName *updateFurniture=[JYUpdateFurnitureName updateFurnitureNameView];
            updateFurniture.delegate=self;
            updateFurniture.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.updateFurniture=updateFurniture;
            [self.view addSubview:self.updateFurniture];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //NSLog(@"长按手势结束");
    }
}

//更改电器名称代理方法
-(void)updateGoGoGo:(NSString *)furnitureName
{
    if(self.updateRow<5)
    {
        [MBProgressHUD showSuccess:@"默认电器不做修改"];
    }
    else
    {
        JYFurnitureSection *section=self.furnitureSecArray[self.updateSecion];
        JYFurniture *furniture=section.furnitureArray[self.updateRow];
        
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        
        //1.创建请求管理对象
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        [mgr setSecurityPolicy:securityPolicy];
        //2.说明服务器返回的是json参数
        mgr.responseSerializer=[AFJSONResponseSerializer serializer];
        
        //3.封装请求参数
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        params[@"is_app"]=@"1";
        params[@"equipment.logic_id"]=furniture.logic_id;
        params[@"equipment.name"]=furnitureName;
        params[@"equipment.scene_name"]=section.sectionName;
        
        //4.发送请求
        [mgr POST:@"http://60.12.220.16:8888/paladin/Equipment/update" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [MBProgressHUD showMessage:@"正在修改..."];
             NSLog(@"ahhahahah%@",responseObject);
             if([responseObject[@"code"]isEqualToString:@"0"])
             {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showSuccess:@"修改成功"];
                 //修改本地电器名称,刷新CollectionView
                 furniture.descLabel=furnitureName;
                 [self.collectionView reloadData];
                  [self.updateFurniture removeFromSuperview];
             }
             else if([responseObject[@"code"]isEqualToString:@"301"])
             {
                 NSLog(@"缺少参数");
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"修改电器名称失败"];
             }
             else if([responseObject[@"code"]isEqualToString:@"307"])
             {
                 NSLog(@"修改电器不存在");
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:@"修改电器不存在"];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"修改电器名称失败"];
             
         }];
    }
}
//取消更改电器名称
-(void)cancelUpdate
{
    [self.updateFurniture removeFromSuperview];
}

#pragma mark - 设置导航栏的按钮

- (void)setNaviBarItemButton
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"家居"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(rightBtnClicked)];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    
  
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - 单行条按钮响应事件

- (void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked
{
    if(self.tag==0)
    {
        self.tag++;
        self.addArea.enabled=NO;
    }
    else
    {
        self.tag--;
        self.addArea.enabled=YES;
    }
    
    //此时你要删除cell了；
    if (self.currentEditState == ProviderEditStateNormal)
    {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.currentEditState = ProviderEditStateDelete;//两个状态切换；
    
        for(CYFCollectionViewCell *cell in self.collectionView.visibleCells)
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            JYFurnitureSection *section=self.furnitureSecArray[indexPath.section];
            JYFurniture *furniture=section.furnitureArray[indexPath.row];
      
            if (indexPath.row != (section.furnitureArray.count - 1))
            {
                if(furniture.registed==NO)
                {
                    [cell.closeButton setHidden:YES];
                }
                else
                {
                    [cell.closeButton setHidden:NO];
                }
            }
            else
            {
                [cell.closeButton setHidden:YES];
            }
        }
    }
    else
    {
        //这是正常情况下；
        self.navigationItem.rightBarButtonItem.title = @"删除";
        self.currentEditState = ProviderEditStateNormal;
        [self.collectionView reloadData];
    }
}

- (void)deleteCellButtonPressed:(id)sender
{
    self.addArea.enabled=YES;
    UIView *v = [sender superview];//获取父类view
    CYFCollectionViewCell *cell = (CYFCollectionViewCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;

    if(indexpath.row<=4)
    {
        JYFurnitureSection *section=self.furnitureSecArray[indexpath.section];
        JYFurniture *furniture=section.furnitureArray[indexpath.row];
        furniture.registed=NO;
        furniture.imageStr=self.imageArray[indexpath.row];
  
        [HttpRequest deleteDeviceFromServer:furniture.logic_id success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [MBProgressHUD showSuccess:@"删除设备成功"];;
            [self rightBtnClicked];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [MBProgressHUD showError:@"删除设备失败"];
        }];
    }
    else
    {
        JYFurnitureSection *section=self.furnitureSecArray[indexpath.section];
        JYFurniture *furniture=section.furnitureArray[indexpath.row];
        [HttpRequest deleteDeviceFromServer:furniture.logic_id success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [section.furnitureArray removeObject:furniture];
            [MBProgressHUD showSuccess:@"删除设备成功"];
            [self rightBtnClicked];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [MBProgressHUD showError:@"删除设备失败"];
        }];
    }
}

@end


