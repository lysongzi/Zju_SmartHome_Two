//
//  STLeftSliderView.h
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STUserInfoViewDelegate <NSObject>

@optional
-(void)goBack;

@end
@interface STUserInfoView : UIView
@property (weak, nonatomic) IBOutlet UITableView *userActTableView;
@property (weak, nonatomic) IBOutlet UIButton *userName;

@property (weak, nonatomic) IBOutlet UIButton *portraitBtn;
- (IBAction)backBtnClick:(id)sender;

+(instancetype)initWithUserView;

@property(nonatomic,weak)id<STUserInfoViewDelegate> delegate;

@end
