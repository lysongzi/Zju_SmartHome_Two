//
//  YSNewPattern.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSNewPattern.h"

@implementation YSNewPattern

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
