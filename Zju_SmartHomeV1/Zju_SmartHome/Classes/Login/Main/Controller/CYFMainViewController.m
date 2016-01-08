//
//  CYFMainViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFMainViewController.h"
//#import "JYMainView.h"
#import "CYFFurnitureViewController.h"
#import "YSProductViewController.h"
#import "RESideMenu.h"
#import "HttpRequest.h"
#import "InternalGateIPXMLParser.h"
#import "AppDelegate.h"
#import "AllUtils.h"
#import "MBProgressHUD+MJ.h"
#import <CoreLocation/CoreLocation.h>
#import "STHomeView.h"
#import "STLeftSliderView.h"
#import "STSliderCell.h"
#import "UIImage+ST.h"
#import "CYFImageStore.h"

@interface CYFMainViewController ()<STHomeViewDelegate,CLLocationManagerDelegate,STLeftSliderViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) CLLocationManager* locationManager;

@property(nonatomic,strong) STHomeView *homeView;
@property(nonatomic,strong) STLeftSliderView *leftView;

@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong)NSArray *imageNames;
@property(nonatomic,strong)NSArray *descArray;
@end

@implementation CYFMainViewController

-(NSArray *)imageNames
{
    if (_imageNames==nil) {
        NSArray *imgNames=[NSArray arrayWithObjects:@"slide_btn_更改网关",@"slide_btn_一键场景",@"slide_btn_一键设备",@"slide_btn_软件说明",@"slide_btn_公司简介", nil];
        _imageNames=imgNames;
    }
    return _imageNames;
}
-(NSArray *)descArray
{
    if (_descArray==nil) {
        NSArray *descArray=[NSArray arrayWithObjects:@"切换网关", @"一键场景",@"一键设备",@"软件说明",@"公司简介",nil];
        _descArray=descArray;
    }
    return _descArray;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  //设置显示的view
  STHomeView *sthomeView=[STHomeView initWithHomeView];
  
  //设置代理
  sthomeView.delegate=self;
  self.homeView = sthomeView;
  self.view =sthomeView;
  
  //设置导航栏
  [self setupNavgationItem];
  
  [self testOpenLocationFunction];
  
  
  //获取内网IP
  [HttpRequest getInternalNetworkGateIP:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //NSLog(@"获取内网返回的数据：%@",result);
    
    //并直接在这里进行解析；
    InternalGateIPXMLParser *parser = [[InternalGateIPXMLParser alloc] initWithXMLString:result];
    // NSLog(@"解析返回：%@",parser.internalIP);
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.globalInternalIP = parser.internalIP;
    
    //    NSLog(@"现在全局的IP是：%@",app.globalInternalIP);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"获取内网返回数据失败：%@",error);
  }];
  
  
}

#pragma mark - 检测定位功能是否开启
- (void)testOpenLocationFunction{
  
  //检测定位功能是否开启
  if([CLLocationManager locationServicesEnabled]){
    
    if(!_locationManager){
      
      self.locationManager = [[CLLocationManager alloc] init];
      
      if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        
      }
      
      //设置代理
      [self.locationManager setDelegate:self];
      //设置定位精度
      [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
      //设置距离筛选
      [self.locationManager setDistanceFilter:100];
      //开始定位
      [self.locationManager startUpdatingLocation];
      //设置开始识别方向
      [self.locationManager startUpdatingHeading];
      
    }
    
  }else{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"您没有开启定位功能"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
    [alertView show];
  }
  
}







//设置导航栏
-(void)setupNavgationItem
{
  UILabel *titleView=[[UILabel alloc]init];
  [titleView setText:@"IQUP"];
  titleView.frame=CGRectMake(0, 0, 100, 16);
  titleView.font=[UIFont systemFontOfSize:16];
  [titleView setTextColor:[UIColor whiteColor]];
  titleView.textAlignment=NSTextAlignmentCenter;
  self.navigationItem.titleView=titleView;
  
  self.leftBtn=[[UIButton alloc]init];
  
//设置用户头像,同时要使这个按钮为圆形；
  
  
  //以下三行代码是设置该按钮为圆形的代码；
  self.leftBtn.frame=CGRectMake(0, 0, 35, 35);
  [self.leftBtn.layer setCornerRadius:CGRectGetHeight([self.leftBtn bounds]) / 2];
  self.leftBtn.layer.masksToBounds = true;
    self.leftBtn.layer.borderWidth=1;
    self.leftBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
  
  
  
  
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //
  //  NSString *isFirstInstall = [defaults valueForKey:@"isFirstInstall"];
  //  NSLog(@"是否已经安装：%@",isFirstInstall);
  //
  //  if (isFirstInstall  == nil) {
  //    //第一次安装；
  //    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
  //    NSLog(@"第一次安装");
  //
  //  }else{
  //
  //    //已经安装；
  //    [self.leftBtn setBackgroundImage:[[CYFImageStore sharedStore] imageForKey:@"CYFStore"] forState:UIControlStateNormal];
  //    NSLog(@"不是第一次安装");
  //  }
  
  
  [self.leftBtn addTarget:self action:@selector(leftPortraitClick) forControlEvents:UIControlEventTouchUpInside];
    
  UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
  self.navigationItem.leftBarButtonItem=leftItem;
}

//左边头像点击事件
-(void)leftPortraitClick
{
    STLeftSliderView *leftView=[STLeftSliderView initWithSliderView];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    leftView.uesername.text=appDelegate.username;
    leftView.userEmail.text=appDelegate.email;
    
    leftView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        leftView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    leftView.delegate=self;
    [leftView.portraitBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
    
    leftView.sliderTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    leftView.sliderTableView.bounces=NO;
    leftView.sliderTableView.dataSource=self;
    leftView.sliderTableView.delegate=self;
    self.leftView=leftView;
    [self.view addSubview:leftView];

}

//STLeftSliderView代理方法
-(void)goBack
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.leftView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.leftView removeFromSuperview];
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"sliderCell";
    STSliderCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (sliderCell==nil)
    {
        sliderCell=[STSliderCell initWithSTSliderCell];
        sliderCell.iconImage.image=[UIImage imageNamed:self.imageNames[indexPath.row]];
        
        [sliderCell.descBtn setTitle:self.descArray[indexPath.row] forState:UIControlStateNormal];
        [sliderCell.descBtn setTitleColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1] forState:UIControlStateNormal];
        
        UIColor *color=[[UIColor alloc]initWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0];
        sliderCell.selectedBackgroundView=[[UIView alloc]initWithFrame:sliderCell.frame];
        sliderCell.selectedBackgroundView.backgroundColor=color;
    }
    
    // Configure the cell...
    
    return sliderCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=50;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}

//代理方法

-(void)officeClick
{
  [MBProgressHUD showError:@"办公室功能尚未开通"];
}

-(void)homeClick
{
    CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
    [self.navigationController pushViewController:jyVc animated:YES];
}
//单品
-(void)singleClick
{
    YSProductViewController *pvc = [[YSProductViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
//自定义
-(void)universalClick
{
  [MBProgressHUD showError:@"通用功能尚未开通"];
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  [self.locationManager stopUpdatingLocation];
  CLLocation* location = locations.lastObject;
  
  [self reverseGeocoder:location];
}


#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
  
  CLGeocoder* geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    
    if(error || placemarks.count == 0)
    {
      
    }
    else
    {
      
      CLPlacemark* placemark = placemarks.firstObject;
      
      NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
      NSString *country = [[placemark addressDictionary] objectForKey:@"Country"];
      
      
      self.homeView.cityLabel.text = [NSString stringWithFormat:@"%@，",city];
      self.homeView.countryLabel.text = country;
    }
    
  }];
}

-(void)officeLabelTap
{
  [MBProgressHUD showError:@"办公室功能尚未开通"];
}
-(void)furnitureTap
{
  CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
  [self.navigationController pushViewController:jyVc animated:YES];
}
-(void)productTap
{
    YSProductViewController *pvc = [[YSProductViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];

}
-(void)customTap
{
  [MBProgressHUD showError:@"自定义功能尚未开通"];
}

#pragma mark - 系统事件回调
- (void)viewDidAppear:(BOOL)animated{
  
  [super viewDidAppear:animated];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *isFirstInstall = [defaults valueForKey:@"isFirstInstall"];
  NSString *isSettedPhoto = [defaults valueForKey:@"isSettedPhoto"];
  
  //重新设置头像；
  if (isFirstInstall  == nil || isSettedPhoto == nil)
  {
    //第一次安装；
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
    [defaults setValue:@"installed" forKey:@"isFirstInstall"];
    
  }
  else
  {
    
    //已经安装；
    [self.leftBtn setBackgroundImage:[[CYFImageStore sharedStore] imageForKey:@"CYFStore"] forState:UIControlStateNormal];
  }
}


@end





