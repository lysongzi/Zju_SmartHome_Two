//
//  YSYWPattern.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/3.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSYWPattern.h"

@implementation YSYWPattern
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName
{
    return [self initWithName:name logoName:logoName bkgName:nil];
}
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName
{
    self = [super init];
    if (self) {
        _name = name;
        _logoName = logoName;
        _bkgName = bkgName;
    }
    return self;
}
@end
