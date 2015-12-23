//
//  QRCatchViewController.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYFurnitureSection.h"


@interface QRCatchViewController : UIViewController
@property(nonatomic,copy)NSString *area;

@property(nonatomic,assign) NSInteger row;
@property(nonatomic,assign) NSInteger section1;

@property(nonatomic,strong) JYFurnitureSection *section;
@property(nonatomic,assign)int tag;

@end
