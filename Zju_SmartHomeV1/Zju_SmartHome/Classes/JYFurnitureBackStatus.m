//
//  JYFurnitureBackStatus.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYFurnitureBackStatus.h"
#import "JYFurnitureBack.h"

@interface JYFurnitureBackStatus()
@property(nonatomic,strong)NSMutableArray *dictArray;
@end
@implementation JYFurnitureBackStatus
+(instancetype)statusWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self.furnitureArray=[[NSMutableArray alloc]init];
    self.dictArray=[[NSMutableArray alloc]init];
    if(self=[super init])
    {
        self.code=dict[@"code"];
        self.msg=dict[@"msg"];
        self.dictArray=dict[@"data"];
        for(NSDictionary *dict in self.dictArray)
        {
            JYFurnitureBack *furnitureBack=[JYFurnitureBack dataWithDict:dict];
            [self.furnitureArray addObject:furnitureBack];
        }
    }
    return self;
}
@end
