//
//  YSYWPatternViewController.h
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/2.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSYWPatternViewController : UIViewController

//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//电器名称
@property(nonatomic,copy)NSString *furnitureName;
//区域名称
@property(nonatomic,copy)NSString *room_name;
//标记是从哪里返回的
@property(nonatomic,assign)int tag_Back;
@end
