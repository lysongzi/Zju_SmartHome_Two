//
//  YSProductViewCell.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/18.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSProductView.h"

@implementation YSProductView

+(instancetype)initProductViewWithXib
{
    YSProductView *productView = [[[NSBundle mainBundle]loadNibNamed:@"YSProductView" owner:nil options:nil]lastObject];
    return productView;
}

@end
