//
//  DLLampControlRGBModeViewController.h
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/2.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSNewPattern.h"

@protocol DLLampControlRGBModeViewDelegate <NSObject>

@optional
-(void)addPattern:(YSNewPattern *)pattern;

@end
@interface DLLampControlRGBModeViewController : UIViewController
//逻辑id
@property(nonatomic,copy)NSString *logic_id;
//模式名称
@property(nonatomic,copy)NSString *patternName;

@property(nonatomic,weak)id<DLLampControlRGBModeViewDelegate>delegate;
@end
