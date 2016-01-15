//
//  YSSceneBackStatus.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/15.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSceneBackStatus : NSObject

//code值
@property(nonatomic,copy)NSString *code;
//返回的场景数据
@property(nonatomic,strong)NSMutableArray *sceneArray;
//返回信息
@property(nonatomic,copy)NSString *msg;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
