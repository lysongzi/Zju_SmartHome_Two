//
//  YSProductViewCell.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/18.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSProductView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *lightImage;

+(instancetype)initProductViewWithXib;

@end
