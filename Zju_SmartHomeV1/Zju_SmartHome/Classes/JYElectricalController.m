//
//  JYElectricalController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/21.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYElectricalController.h"
#import "AFNetworking.h"

@interface JYElectricalController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,strong)NSMutableData *receiveData;
@end

@implementation JYElectricalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self test2];
}
-(void)test2
{
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Equipment/find" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"看看返回的数据是啥呢？%@",responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回失败了吧：%@",error);
     }];
}

//这里要传哪些参数可以再修改；
- (void)test{
    
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//    "<root>"
//    "<command_id>10001</command_id>"
//    "<command_type>execute</command_type>"
//    "<id>123</id>"
//    "<action>warmcold</action>"
//    "<value>80</value>"
//    "</root>";
    
    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<root>"
    "<command_id></command_id>"
    "<command_type>execute</command_type>"
    "<id>145</id>"
    "<action>open</action>"
    "<value>005D8CFF00158D00</value>"
    "</root>";
    
    NSDictionary *parameters = @{@"test" : str};
    
//    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/getLogicIdfromMac.php"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
              NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"成功: %@", string);
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
              NSLog(@"失败: %@", error);
          }];
}

@end
