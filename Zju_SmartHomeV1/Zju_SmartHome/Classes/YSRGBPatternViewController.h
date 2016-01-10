//
//  YSRGBPatternViewController.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSRGBPatternViewController : UIViewController
//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//电器名称
@property(nonatomic,copy)NSString *furnitureName;

//标记是从哪里返回的
@property(nonatomic,assign)int tag_Back;
//区域名称
@property(nonatomic,copy)NSString *room_name;
@end
