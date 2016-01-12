//
//  DLLampControlRGBModeViewController.h
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/2.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPattern.h"

@protocol DLLampControlRGBModeViewDelegate <NSObject>

@optional
-(void)addPattern:(JYPattern *)pattern;

@end
@interface DLLampControlRGBModeViewController : UIViewController
//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//电器名称
@property(nonatomic,copy)NSString *furnitureName;
//模式名称
@property(nonatomic,copy)NSString *patternName;

//表名
@property(nonatomic,copy)NSString *tableName;

@property(nonatomic,weak)id<DLLampControlRGBModeViewDelegate>delegate;
@end
