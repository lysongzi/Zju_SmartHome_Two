//
//  JYFurnitureBack.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYFurnitureBack.h"

@implementation JYFurnitureBack
+(instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self=[super init])
    {
        self.logic_id=dict[@"logic_id"];
        self.scene_name=dict[@"room_name"];
        self.name=dict[@"name"];
        self.deviceType=dict[@"type"];
    }
    return self;
}
@end
