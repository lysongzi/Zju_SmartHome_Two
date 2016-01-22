//
//  DLLampControllYWModeViewController.h
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/1.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLampControllYWModeViewController : UIViewController
//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//电器名称
@property(nonatomic,copy)NSString *furnitureName;
//区域
@property(nonatomic,copy)NSString *area;
//表名
@property(nonatomic,copy)NSString *tableName;
//场景中自定义电器颜色会用到
@property(nonatomic,assign)int sceneTag;
@end
