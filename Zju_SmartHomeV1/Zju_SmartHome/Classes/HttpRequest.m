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
  
    [MBProgressHUD showMessage:@"正在注册..."];
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
  
  if (app.isInternalNetworkGate)
  {
    //内网；
    NSString *url  = [[NSString alloc] initWithFormat:@"http://%@/phone/getLogicIdfromMac.php",app.globalInternalIP];
    
    [manager POST:url
       parameters:parameters
          success:success
          failure:failure];
  }else{
    //外网；
    //默认使用外网；
    [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/getLogicIdfromMac.php"
       parameters:parameters
          success:success
          failure:failure];
  }
  
}
#pragma mark-根据协议和值得到具体对音乐的操作
+ (void)getMusicActionfromProtol:(NSString*)protolName success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure
{
    //    [MBProgressHUD showMessage:@"正在注册..."];
    NSLog(@"%@",protolName);
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
                     "<id>5</id>"
                     "<action>%@</action>"
                     "<value></value>"
                     "</root>",protolName];
    
    NSDictionary *parameters = @{@"test" : str};
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if (app.isInternalNetworkGate) {
        //内网；
        
        NSLog(@"内网获取逻辑ID的IP：%@",[[NSString alloc] initWithFormat:@"http://%@/phone/background_music.php",app.globalInternalIP]);
        
        //NSString *url  = [[NSString alloc] initWithFormat:@"http://%@/phone/background_music.php",app.globalInternalIP];
        
        [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/background_music.php"
           parameters:parameters
              success:success
              failure:failure];
        NSLog(@"使用内网 向网关发送Mac值");
    }else{
        //外网；
        //默认使用外网；
        //http://test.ngrok.joyingtec.com:8000/phone/background_music.php
        [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/background_music.php"
           parameters:parameters
              success:success
              failure:failure];
        //        [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/background_music.php"
        //           parameters:parameters
        //              success:success
        //              failure:failure];
        
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
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.name":deviceName,
                           @"equipment.logic_id":logicId,
                           @"equipment.room_name" :sectionName,
                           @"equipment.type":type
                           };
  
  //外网发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/create"
     parameters:params
        success:success
        failure:failure];
  
}

//****************
//单品中添加电器
+ (void)registerDeviceToServerProduct:(NSString*)logicId deviceName:(NSString*)deviceName  type:(NSString*)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *params = @{@"is_app":@"1",
                             @"equipment.room_name":@"-1",
                             @"equipment.name":deviceName,
                             @"equipment.logic_id":logicId,
                             @"equipment.type":type
                             };
    
    //外网发送请求
    [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/create"
       parameters:params
          success:success
          failure:failure];
    
}
//****************
#pragma mark - 从服务器获取家具所有设备的方法
+ (void)findAllDeviceFromServer :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success  failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
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
}

//从单品中获取所有电器
+ (void)findAllDeviceFromServerProduct :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
    [MBProgressHUD showMessage:@"正在加载..."];
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"equipment.room_name"]=@"-1";
    
    
    //外网；
    [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/find"
       parameters:params
          success:success
          failure:failure];
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
  [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/ip.php"
     parameters:params
        success:success
        failure:failure];
}

#pragma mark - 删除电器网络请求方法
//删除电器网络请求方法
+ (void)deleteDeviceFromServer:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
  
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.logic_id":logicId
                           };
  //外网发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/delete"
     parameters:params
        success:success
        failure:failure];
  
}

//单品删除电器
+ (void)deleteDeviceFromServerProduct:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{@"is_app":@"1",
                             @"is_sample":@"1",
                             @"equipment.logic_id":logicId
                             };
    //外网发送请求
    [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/delete"
       parameters:params
          success:success
          failure:failure];
}

//模式的查询,该方法没有封装

//电器模式的删除
+ (void)deletePatternFromServerProduct:(NSString*)logicId andWithPatternName:(NSString *)patternName withArea:(NSString *)area success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"sceneconfig.tag"]=@"0";
    params[@"sceneconfig.room_name"]=area;
    params[@"sceneconfig.equipment_logic_id"]=logicId;
    params[@"sceneconfig.scene_name"]=patternName;
    
    NSLog(@"删除电器所传参数: %@ %@  %@ %@",logicId, patternName,params[@"sceneconfig.tag"],area);
    
    //外网发送请求
    [manager POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/delete"
       parameters:params
          success:success
          failure:failure];
}

//电器模式的增加，该方法没有封装

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
  }else{
    
    //外网；
    [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
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
  }else{
    //外网；
    [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
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
    
  }else{
    
    //外网
    [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/yw_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
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
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网
    
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/color_light.php",app.globalInternalIP]
       parameters:parameters
          success:success
          failure:failure];

  }else{
    
    //外网
    [manager POST:@"http://iphone.ngrok.joyingtec.com:8000/phone/color_light.php"
       parameters:parameters
          success:success
          failure:failure];
    
  }
  
}


@end
