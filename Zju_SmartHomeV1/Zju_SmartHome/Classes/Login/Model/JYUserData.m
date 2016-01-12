//
//  JYUserData.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYUserData.h"

@implementation JYUserData

+(instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self=[super init])
    {
        self.account=dict[@"account"];
        self.avatar=dict[@"avatar"];
        self.email=dict[@"email"];
        self.ID=dict[@"id"];
    }
    return self;
}


//从文件中解析对象的时候调用（解码）
-(id)initWithCoder:(NSCoder *)decoder
{
    if(self=[super init])
    {
        self.account=[decoder decodeObjectForKey:@"account"];
        
    }
    return self;
}

//将对象写入文件的时候调用
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.account forKey:@"account"];
}

@end
