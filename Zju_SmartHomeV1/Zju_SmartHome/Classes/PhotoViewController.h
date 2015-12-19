//
//  PhotoViewController.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/12/12.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

//电灯操作页面传递过来的类型，是打开照相机还是图库；
@property(nonatomic,assign)UIImagePickerControllerSourceType openType;

@property(nonatomic,copy)NSString *logic_id;

@end
