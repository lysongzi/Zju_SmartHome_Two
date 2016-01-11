//
//  JYPatternBackStatus.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/11.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "JYPatternBackStatus.h"
#import "JYPattern.h"

@interface JYPatternBackStatus()
@property(nonatomic,strong)NSMutableArray *dictArray;
@end

@implementation JYPatternBackStatus
+(instancetype)statusWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self.patternArray=[[NSMutableArray alloc]init];
    self.dictArray=[[NSMutableArray alloc]init];
    if(self=[super init])
    {
        self.code=dict[@"code"];
        self.msg=dict[@"msg"];
        self.dictArray=dict[@"data"];
        for(NSDictionary *dict in self.dictArray)
        {
            JYPattern *backPattern=[JYPattern statusWithDict:dict];
            [self.patternArray addObject:backPattern];
        }
    }
    return self;
}
@end
