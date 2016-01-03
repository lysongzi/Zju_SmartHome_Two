//
//  JYFurnitureView.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFurnitureView : UIView
//自定义View中电器图片
@property (weak, nonatomic) IBOutlet UIImageView *imageBtn;
//自定义View中电器描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//右上角删除按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//背景发光
@property (weak, nonatomic) IBOutlet UIImageView *lightImage;

+(instancetype)furnitureViewXib;
@end
