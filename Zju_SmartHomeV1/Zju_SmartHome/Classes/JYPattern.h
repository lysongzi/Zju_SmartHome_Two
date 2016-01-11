//
//  JYPattern.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYPattern : NSObject

//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//模式名称
@property (copy, nonatomic) NSString *name;
//模式logo(这个属性数据库不需要，根据name判断即可)
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;

//三个参数(RGB灯存放rgb值，YW灯只用到前2个参数，存放YW值)
@property(nonatomic,copy)NSString *param1;
@property(nonatomic,copy)NSString *param2;
@property(nonatomic,copy)NSString *param3;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
