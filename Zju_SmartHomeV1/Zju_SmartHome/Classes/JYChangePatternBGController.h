//
//  JYChangePatternBGController.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 16/1/4.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePatternBGDelegate <NSObject>

@optional
//RGB模式中修改背景图片
-(void)changBG:(UIImage *)image;
//YW模式中修改背景图片
-(void)changBG_YW:(UIImage *)image;
//场景中修改背景图片
-(void)changeBG_Scene:(UIImage *)image;

@end

@interface JYChangePatternBGController : UIViewController
//电灯操作页面传递过来的类型，是打开照相机还是图库；
@property(nonatomic,assign)UIImagePickerControllerSourceType openType;

@property(nonatomic,copy)NSString *logic_id;

@property(nonatomic,weak)id<ChangePatternBGDelegate>delegate;
@end

