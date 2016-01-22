//
//  HttpRequest.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject


//使用mac值获取logic值；
+ (void)getLogicIdfromMac:(NSString*)macValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//根据协议和值得到操作
+ (void)getMusicActionfromProtol:(NSString*)protolName  success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//把logicId发送到服务器；
+ (void)registerDeviceToServer:(NSString*)logicId deviceName:(NSString*)deviceName sectionName:(NSString*)sectionName type:(NSString *)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//从服务器获得所有的注册设备；
+ (void)findAllDeviceFromServer :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//从单品中获取所有注册电器
+ (void)findAllDeviceFromServerProduct :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;
//从单品中注册所有电器
+ (void)registerDeviceToServerProduct:(NSString*)logicId deviceName:(NSString*)deviceName  type:(NSString*)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;


//从网关获取内网IP；
+ (void)getInternalNetworkGateIP:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//删除设备
+ (void)deleteDeviceFromServer:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;
//单品删除设备
+ (void)deleteDeviceFromServerProduct:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;
//电器模式的删除
+ (void)deletePatternFromServerProduct:(NSString*)logicId andWithPatternName:(NSString *)patternName withArea:(NSString *)area success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//YW灯冷暖
+ (void)sendYWWarmColdToServer:(NSString *)logicId warmcoldValue:(NSString*)warmcoldValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//YW灯亮度
+ (void)sendYWBrightnessToServer:(NSString *)logicId brightnessValue:(NSString*)brightnessValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//RGB亮度
+ (void)sendRGBBrightnessToServer:(NSString *)logicId brightnessValue:(NSString*)brightnessValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//RGB三种颜色
+ (void)sendRGBColorToServer:(NSString *)logicId redValue:(NSString*)redValue greenValue:(NSString*)greenValue blueValue:(NSString*)blueValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//根据区域,场景名称和电器逻辑id删除指定场景下的电器
+ (void)deleteSceneFromServer:(NSString*)logicId andWithSceneName:(NSString *)sceneName withArea:(NSString *)area success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;
    

@end
