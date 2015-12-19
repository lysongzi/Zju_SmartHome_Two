//
//  CYFMainViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFMainViewController.h"
#import "JYMainView.h"
#import "CYFFurnitureViewController.h"
#import "RESideMenu.h"
#import "HttpRequest.h"
#import "InternalGateIPXMLParser.h"
#import "AppDelegate.h"
#import "AllUtils.h"
#import "MBProgressHUD+MJ.h"
#import <CoreLocation/CoreLocation.h>

#import "CYFImageStore.h"

@interface CYFMainViewController ()<JYMainViewDelegate,CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager* locationManager;

@property(nonatomic,strong) JYMainView *mainView;

@property (nonatomic,strong) UIButton *leftBtn;



@end

@implementation CYFMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  
  //设置显示的view
  JYMainView *jyMainView=[JYMainView mainViewXib];
  
  jyMainView.officeLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *officeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(officeLabelTap)];
  [jyMainView.officeLabel addGestureRecognizer:officeTap];
  
  jyMainView.furnitureLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *furnitureTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(furnitureTap)];
  [jyMainView.furnitureLabel addGestureRecognizer:furnitureTap];
  
  jyMainView.productLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *productTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productTap)];
  [jyMainView.productLabel addGestureRecognizer:productTap];
  
  jyMainView.customLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *customTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customTap)];
  [jyMainView.customLabel addGestureRecognizer:customTap];
  
  
  
  //设置代理
  jyMainView.delegate=self;
  self.mainView = jyMainView;
  self.view =jyMainView;
  
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
  
  /*
   [view.layer setCornerRadius:CGRectGetHeight([view bounds]) / 2];
   view.layer.masksToBounds = YES;
   
   
   view.layer.borderWidth = 5;
   view.layer.borderColor = [[UIColor whiteColor] CGColor];
   view.layer.contents = (id)[[UIImage imageNamed:@"backgroundImage.png"] CGImage];
   
   */
  //设置用户头像,同时要使这个按钮为圆形；
  
  
  //以下三行代码是设置该按钮为圆形的代码；
  self.leftBtn.frame=CGRectMake(0, 0, 28, 28);
  [self.leftBtn.layer setCornerRadius:CGRectGetHeight([self.leftBtn bounds]) / 2];
  self.leftBtn.layer.masksToBounds = true;
  
  
  
  
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
  
  
  [self.leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
  self.navigationItem.leftBarButtonItem=leftItem;
}

//左边头像点击事件
-(void)leftPortraitClick
{
  
}

//代理方法
//家居
-(void)furnitureClick
{
  CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
  [self.navigationController pushViewController:jyVc animated:YES];
}
//办公室
-(void)officeClick
{
  [MBProgressHUD showError:@"办公室功能尚未开通"];
}
//单品
-(void)productClick
{
  [MBProgressHUD showError:@"单品功能尚未开通"];
}
//自定义
-(void)customClick
{
  [MBProgressHUD showError:@"自定义功能尚未开通"];
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
    
    if(error || placemarks.count == 0){
      NSLog(@"error = %@",error);
    }else{
      
      CLPlacemark* placemark = placemarks.firstObject;
      NSLog(@"城市:%@",[[placemark addressDictionary] objectForKey:@"City"]);
      NSLog(@"国家:%@",[[placemark addressDictionary] objectForKey:@"Country"]);
      
      NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
      NSString *country = [[placemark addressDictionary] objectForKey:@"Country"];
      
      
      self.mainView.cityLabel.text = city;
      self.mainView.countryLabel.text = country;
      
      
      //      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      //
      //      [alert show];
      
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
  [MBProgressHUD showError:@"单品功能尚未开通"];
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
  

  NSLog(@"是否已经安装：%@",isFirstInstall);
  
  //重新设置头像；
  if (isFirstInstall  == nil || isSettedPhoto == nil) {
    //第一次安装；
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
    [defaults setValue:@"installed" forKey:@"isFirstInstall"];
    NSLog(@"第一次安装");
    
  }else{
    
    //已经安装；
    [self.leftBtn setBackgroundImage:[[CYFImageStore sharedStore] imageForKey:@"CYFStore"] forState:UIControlStateNormal];
    NSLog(@"不是第一次安装");
  }
  
  
  
  
}


@end





