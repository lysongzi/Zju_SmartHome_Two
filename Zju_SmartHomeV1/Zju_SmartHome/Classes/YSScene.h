//
//  YSScene.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSScene : NSObject
//区域
@property(nonatomic,copy)NSString *area;
//场景名称
@property (copy, nonatomic) NSString *name;
//场景logo
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;

//某场景下电器的数组
//@property(nonatomic,strong)NSMutableArray *furnituresArray;

//电器逻辑id
@property(nonatomic,copy)NSString *logic_id;
//电器的类型
@property(nonatomic,copy)NSString *type;

//三个参数
@property(nonatomic,copy)NSString *param1;
@property(nonatomic,copy)NSString *param2;
@property(nonatomic,copy)NSString *param3;

+(instancetype)statusWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
