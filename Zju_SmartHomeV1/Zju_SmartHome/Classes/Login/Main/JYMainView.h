//
//  JYMainVIew.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYMainViewDelegate <NSObject>

@optional
-(void)officeClick;
-(void)furnitureClick;
-(void)productClick;
-(void)customClick;
@end

@interface JYMainView : UIView
+(instancetype)mainViewXib;
@property(nonatomic,weak)id<JYMainViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *officeLabel;
@property (weak, nonatomic) IBOutlet UILabel *furnitureLabel;

@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;

//定位

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
