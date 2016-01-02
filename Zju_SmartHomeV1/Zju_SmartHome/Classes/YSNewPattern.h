//
//  YSNewPattern.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNewPattern : NSObject

//模式名称
@property (copy, nonatomic) NSString *name;
//模式logo
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;
//RGB颜色值
@property(nonatomic,copy)NSString *rValue;
@property(nonatomic,copy)NSString *gValue;
@property(nonatomic,copy)NSString *bValue;

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName;
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName;

@end
