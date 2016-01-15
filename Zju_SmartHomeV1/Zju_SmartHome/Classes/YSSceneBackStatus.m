//
//  YSSceneBackStatus.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/15.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSSceneBackStatus.h"
#import "YSScene.h"

@interface YSSceneBackStatus ()

@property(nonatomic,strong)NSMutableArray *dictArray;

@end

@implementation YSSceneBackStatus

+(instancetype)statusWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self.sceneArray = [[NSMutableArray alloc]init];
    self.dictArray = [[NSMutableArray alloc]init];
    
    if(self = [super init])
    {
        self.code = dict[@"code"];
        self.msg = dict[@"msg"];
        self.dictArray = dict[@"data"];
        for(NSDictionary *dict in self.dictArray)
        {
            YSScene *backScene = [YSScene statusWithDict:dict];
            [self.sceneArray addObject:backScene];
        }
    }
    return self;
}

@end
