//
//  YSYWPattern.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/3.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSYWPattern : NSObject
//模式名称
@property (copy, nonatomic) NSString *name;
//模式logo
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;
//Y值
@property(nonatomic,copy)NSString *rValue;
//W值
@property(nonatomic,copy)NSString *gValue;

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName;
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName;
@end
