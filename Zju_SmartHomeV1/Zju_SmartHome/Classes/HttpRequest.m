//
//  HttpRequest.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

#import "AppDelegate.h"

#import "MBProgressHUD+MJ.h"

@implementation HttpRequest

#pragma mark - 从网关获取逻辑ID的方法
+ (void)getLogicIdfromMac:(NSString*)macValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id></command_id>"
                   "<command_type>execute</command_type>"
                   "<id>145</id>"
                   "<action>open</action>"
                   "<value>%@</value>"
                   "</root>",macValue];
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网；
    
    NSLog(@"内网获取逻辑ID的IP：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/getLogicIdfromMac.php",app.globalInternalIP]);
    
    NSString *url  = [[NSString alloc] initWithFormat:@"http://%@/phone/getLogicIdfromMac.php",app.globalInternalIP];
    
    [manager POST:url
       parameters:parameters
          success:success
          failure:failure];
     NSLog(@"使用内网 向网关发送Mac值");
  }else{
    //外网；
    //默认使用外网；
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/getLogicIdfromMac.php"
       parameters:parameters
          success:success
          failure:failure];
    
     NSLog(@"使用外网 向网关发送Mac值");
    
  }
  
}

#pragma mark - 把设备注册到服务器的方法
+ (void)registerDeviceToServer:(NSString*)logicId deviceName:(NSString*)deviceName sectionName:(NSString*)sectionName type:(NSString*)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
  
  //3.封装请求参数
  //  NSMutableDictionary *params=[NSMutableDictionary dictionary];
  //  params[@"is_app"] = @"1";
  //  params[@"equipment.name"] = deviceName;
  //  params[@"equipment.logic_id"] = logicId;
  //  params[@"equipment.scene_name"] = sectionName;
  
  
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.name":deviceName,
                           @"equipment.logic_id":logicId,
                           @"equipment.scene_name" :sectionName,
                           @"equipment.type":type
                           };
  
  //外网发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/create"
     parameters:params
        success:success
        failure:failure];
  
  // NSLog(@"使用外网 向服务器注册设备");
}


#pragma mark - 从服务器获取所有设备的方法
+ (void)findAllDeviceFromServer :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //  [MBProgressHUD showMessage:@"正在加载..."];
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFJSONResponseSerializer serializer];
  
  //3.封装请求参数
  NSMutableDictionary *params=[NSMutableDictionary dictionary];
  params[@"is_app"]=@"1";
  
  
  //外网；
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/find"
     parameters:params
        success:success
        failure:failure];
  
  // NSLog(@"使用外网从服务器获取所有注册设备");
  
  
}

#pragma mark - 获取内网地址的方法
+ (void)getInternalNetworkGateIP:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id>10001</command_id>"
                   "<command_type>get</command_type>"
                   "<id>123</id>"
                   "<action>get_gateway_ip</action>"
                   "<value>100</value>"
                   "</root>"];
  
  NSDictionary *params = @{@"test" : str};
  
  //通过外网来获取内网的IP地址；
  [manager POST:@"http://test.ngrok.joyingtec.com:8000/ip.php"
     parameters:params
        success:success
        failure:failure];
  // NSLog(@"获取内网IP地址。。。");
  
}

#pragma mark - 删除电器网络请求方法
//删除电器网络请求方法
+ (void)deleteDeviceFromServer:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
  
  // NSLog(@"====PPPPP %@",logicId);
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.logic_id":logicId
                           };
  //外网发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/delete"
     parameters:params
        success:success
        failure:failure];
  
  //  NSLog(@"使用外网 向服务器注册设备");
  
}

#pragma mark - 向服务器发送YW灯冷暖的方法
+ (void)sendYWWarmColdToServer:(NSString *)logicId warmcoldValue:(NSString*)warmcoldValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id>10001</command_id>"
                   "<command_type>execute</command_type>"
                   "<id>%@</id>"
                   "<action>change_color</action>"
                   "<value>%@</value>"
                   "</root>",logicId,warmcoldValue];
  
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网；
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]
       parameters:parameters
          success:success
          failure:failure];
    NSLog(@"使用内网控制YW冷暖：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]);
    
  }else{
    
    //外网；
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用外网控制YW冷暖");
    
  }
  
  
}


#pragma mark - 向服务器发送YW灯亮度的方法
+ (void)sendYWBrightnessToServer:(NSString *)logicId brightnessValue:(NSString*)brightnessValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id>10001</command_id>"
                   "<command_type>execute</command_type>"
                   "<id>%@</id>"
                   "<action>change_bright</action>"
                   "<value>%@</value>"
                   "</root>",logicId,brightnessValue];
  
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    
    //内网；
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]
       parameters:parameters
          success:success
          failure:failure];
    
     NSLog(@"使用内网控制YW亮度：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]);
    
  }else{
    //外网；
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用外网控制YW亮度");
    
  }
  
}


#pragma mark -向服务器发送RGB灯亮度的方法
+ (void)sendRGBBrightnessToServer:(NSString *)logicId brightnessValue:(NSString*)brightnessValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id>1</command_id>"
                   "<command_type>execute</command_type>"
                   "<id>%@</id>"
                   "<action>change_bright</action>"
                   "<value>%@</value>"
                   "</root>",logicId,brightnessValue];
  
  
  NSDictionary *parameters = @{@"test" : str};
  
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  
  if (app.isInternalNetworkGate) {
    
    //内网；
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用内网控制RGB亮度：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/yw_light.php",app.globalInternalIP]);
    
    
  }else{
    
    //外网
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用外网控制RGB亮度");
    
  }
  
}


#pragma mark - 向服务器发送RGB灯颜色的方法
+ (void)sendRGBColorToServer:(NSString *)logicId redValue:(NSString*)redValue greenValue:(NSString*)greenValue blueValue:(NSString*)blueValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  
  //增加这几行代码
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id></command_id>"
                   "<command_type>execute</command_type>"
                   "<id>%@</id>"
                   "<action>change_color</action>"
                   "<value>%@,%@,%@</value>"
                   "</root>",  logicId,redValue,greenValue,blueValue];
  NSLog(@"-----%@ %@ %@",redValue,greenValue,blueValue);
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网
    
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/color_light.php",app.globalInternalIP]
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用内网控制RGB颜色：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/color_light.php",app.globalInternalIP]);
    
  }else{
    
    //外网
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/color_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用外网控制GRB颜色");
    
  }
  
}


@end
