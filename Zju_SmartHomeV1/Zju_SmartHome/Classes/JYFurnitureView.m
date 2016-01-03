//
//  JYFurnitureView.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYFurnitureView.h"

@interface JYFurnitureView()
@end

@implementation JYFurnitureView

+(instancetype)furnitureViewXib
{
    JYFurnitureView *furnitureViewXib=[[[NSBundle mainBundle]loadNibNamed:@"JYFurnitureViewXib" owner:nil options:nil]lastObject];
    return furnitureViewXib;
}

@end
