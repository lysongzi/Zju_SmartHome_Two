//
//  YSSceneViewController.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSSceneViewController : UIViewController

@property(nonatomic,copy)NSString *logic_id;
//标记是从哪里返回的
@property(nonatomic,assign)int tag_Back;
//区域的名称
@property(nonatomic,copy) NSString *sectionName;
//区域电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;

@end
