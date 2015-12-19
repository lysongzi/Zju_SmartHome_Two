//
//  JYMainVIew.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYMainView.h"
@interface JYMainView()

//办公室
@property (weak, nonatomic) IBOutlet UIButton *office;
- (IBAction)officeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *officeView;
//@property (weak, nonatomic) IBOutlet UILabel *officeLabel;

//家居
@property (weak, nonatomic) IBOutlet UIButton *furniture;
- (IBAction)furnitureClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *furnitureView;


//单品
@property (weak, nonatomic) IBOutlet UIButton *product;
- (IBAction)productClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *productVIew;

//自定义
@property (weak, nonatomic) IBOutlet UIButton *custom;
- (IBAction)customClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *customView;




@end

@implementation JYMainView

+(instancetype)mainViewXib
{
    JYMainView *mainViewXib=[[[NSBundle mainBundle]loadNibNamed:@"JYMainXib" owner:nil options:nil]lastObject];
    
    //设置圆角
    mainViewXib.office.layer.cornerRadius=3;
    mainViewXib.office.layer.masksToBounds=YES;
    mainViewXib.officeView.layer.cornerRadius=3;
    mainViewXib.officeView.layer.masksToBounds=YES;
    [mainViewXib.office setAdjustsImageWhenHighlighted:NO];
    
    
    mainViewXib.furniture.layer.cornerRadius=3;
    mainViewXib.furniture.layer.masksToBounds=YES;
    mainViewXib.furnitureView.layer.cornerRadius=3;
    mainViewXib.furnitureView.layer.masksToBounds=YES;
    [mainViewXib.furniture setAdjustsImageWhenHighlighted:NO];
    
    mainViewXib.product.layer.cornerRadius=3;
    mainViewXib.product.layer.masksToBounds=YES;
    mainViewXib.productVIew.layer.cornerRadius=3;
    mainViewXib.productVIew.layer.masksToBounds=YES;
    [mainViewXib.product setAdjustsImageWhenHighlighted:NO];
    
    mainViewXib.custom.layer.cornerRadius=3;
    mainViewXib.custom.layer.masksToBounds=YES;
    mainViewXib.customView.layer.cornerRadius=3;
    mainViewXib.customView.layer.masksToBounds=YES;
    [mainViewXib.custom setAdjustsImageWhenHighlighted:NO];
    
    return mainViewXib;
}

- (IBAction)officeClick:(id)sender
{
   if([self.delegate respondsToSelector:@selector(officeClick)])
   {
       [self.delegate officeClick];
   }
}

- (IBAction)furnitureClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(furnitureClick)])
    {
        [self.delegate furnitureClick];
    }
}
- (IBAction)productClick:(id)sender
{
     if([self.delegate respondsToSelector:@selector(productClick)])
     {
         [self.delegate productClick];
     }
}
- (IBAction)customClick:(id)sender
{
     if([self.delegate respondsToSelector:@selector(customClick)])
     {
         [self.delegate customClick];
     }
}


@end
