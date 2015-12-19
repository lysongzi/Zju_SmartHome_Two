//
//  JYLoginStatus.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYLoginStatus.h"
#import "JYUserData.h"
@implementation JYLoginStatus

+(instancetype)statusWithDict:(NSDictionary *)dict
{
    return  [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self=[super init])
    {
        self.code=dict[@"code"];
        if(![dict[@"data"]isEqual:@""])
        {
            self.data=[JYUserData dataWithDict:dict[@"data"]];
        }
        self.msg=dict[@"msg"];
    }
    
    return  self;
}
@end
