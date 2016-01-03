//
//  YSProductViewCell.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSProductViewCell.h"
#import "YSProductView.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define UISCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface YSProductViewCell ()

@property (strong, nonatomic) YSProductView *productView;

@end

@implementation YSProductViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        YSProductView *productView = [YSProductView initProductViewWithXib];
        self.productView = productView;
        
        [self addSubview:self.productView];
        
        self.imageView = productView.imageView;
        self.descLabel = productView.descLabel;
        self.closeButton = productView.closeButton;
        self.lightImage = productView.lightImage;
    }
    return self;
}

//这个方法里调整控件frame是最准确的
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.productView.frame = CGRectMake(0, 0, (UISCREEN_WIDTH - 36)/ 3 - 0.5,  (UISCREEN_WIDTH - 36)/ 3 - 0.5);
}

@end
