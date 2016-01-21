//
//  JYSceneOnly.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/21.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSceneOnly : NSObject
//区域
@property(nonatomic,copy)NSString *area;
//场景名称
@property (copy, nonatomic) NSString *name;
//场景logo
@property (copy, nonatomic) NSString *logoName;
//模式背景图片
@property (copy, nonatomic) NSString *bkgName;
@end
