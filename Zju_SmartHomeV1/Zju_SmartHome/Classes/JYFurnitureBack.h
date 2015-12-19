//
//  JYFurnitureBack.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFurnitureBack : NSObject
//设备逻辑id
@property(nonatomic,copy)NSString *logic_id;
//设备所在区域
@property(nonatomic,copy)NSString *scene_name;
//设备名称
@property(nonatomic,copy)NSString *name;
//设备类型
@property(nonatomic,copy)NSString *deviceType;

+(instancetype)dataWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
