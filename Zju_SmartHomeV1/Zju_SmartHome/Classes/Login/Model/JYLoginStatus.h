//
//  JYLoginStatus.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYUserData;
@interface JYLoginStatus : NSObject

//code值
@property(nonatomic,copy)NSString *code;
//返回的用户数据
@property(nonatomic,strong)JYUserData *data;
//返回信息
@property(nonatomic,copy)NSString *msg;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
