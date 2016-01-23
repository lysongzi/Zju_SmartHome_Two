//
//  STUserInfoController.h
//  个人信息demo
//
//  Created by 123 on 16/1/8.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STEditSceneController : UIViewController
//区域
@property(nonatomic,copy)NSString *area;
//场景名称
@property(nonatomic,copy)NSString *scene_name;
//该区域该场景下的灯
@property(nonatomic,strong)NSMutableArray *editFurnitureArray;
//该区域下所有灯
@property(nonatomic,strong)NSMutableArray *furnitureArray;
@end
