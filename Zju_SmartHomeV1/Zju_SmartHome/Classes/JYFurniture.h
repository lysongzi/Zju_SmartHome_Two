//
//  JYFurniture.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/21.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@interface JYFurniture : NSObject
//电器图片
@property(nonatomic,copy)NSString *imageStr;
//电器描述
@property(nonatomic,copy)NSString *descLabel;
//是否注册过(注册过电器图片高亮)
@property(nonatomic,assign)BOOL registed;

@property(nonatomic,copy)NSString *logic_id;

//电器类型
@property(nonatomic,copy)NSString *deviceType;

//点击后进入的controller
@property(nonatomic,strong)UIViewController *controller;

//只在场景中需要使用该属性
@property(nonatomic,assign)int isNeeded;
@end
