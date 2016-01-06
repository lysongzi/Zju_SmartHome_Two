//
//  YSScene.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSScene : NSObject

//模式名称
@property (copy, nonatomic) NSString *name;
//模式logo
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName;
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName;

@end
