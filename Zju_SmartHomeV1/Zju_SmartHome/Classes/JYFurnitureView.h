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
//底部的线
@property (weak, nonatomic) IBOutlet UIView *bottomX;
//右边的线
@property (weak, nonatomic) IBOutlet UIView *rightX;
//顶部的线
@property (weak, nonatomic) IBOutlet UIView *topX;


@property (weak, nonatomic) IBOutlet UIButton *closeButton;

+(instancetype)furnitureViewXib;
@end
