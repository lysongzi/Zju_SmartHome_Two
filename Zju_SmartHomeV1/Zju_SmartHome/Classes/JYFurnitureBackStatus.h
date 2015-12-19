//
//  JYFurnitureBackStatus.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFurnitureBackStatus : NSObject

//code值
@property(nonatomic,copy)NSString *code;
//返回的设备数据
@property(nonatomic,strong)NSMutableArray *furnitureArray;
//返回信息
@property(nonatomic,copy)NSString *msg;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
