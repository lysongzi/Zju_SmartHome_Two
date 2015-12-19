//
//  JYFurnitureSection.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/25.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFurnitureSection : NSObject
//智能区域名称
@property(nonatomic,copy)NSString *sectionName;
//电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;
@end
