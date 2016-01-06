//
//  YSScene.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSScene.h"

@implementation YSScene

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName
{
    return [self initWithName:name logoName:logoName bkgName:nil];
}

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName
{
    if (self = [super init])
    {
        _name = name;
        _logoName = logoName;
        _bkgName = bkgName;
    }
    return self;
}

@end
