//
//  JYSceneFurniture.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/8.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSceneFurniture : NSObject
//电器逻辑id
@property(nonatomic,copy)NSString *logic_id;

//三个参数
@property(nonatomic,copy)NSString *param1;
@property(nonatomic,copy)NSString *param2;
@property(nonatomic,copy)NSString *param3;
@end
