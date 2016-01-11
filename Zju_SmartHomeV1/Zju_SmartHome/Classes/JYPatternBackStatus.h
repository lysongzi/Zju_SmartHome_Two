//
//  JYPatternBackStatus.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/11.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYPatternBackStatus : NSObject
//code值
@property(nonatomic,copy)NSString *code;
//返回的模式数据
@property(nonatomic,strong)NSMutableArray *patternArray;
//返回信息
@property(nonatomic,copy)NSString *msg;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
