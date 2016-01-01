//
//  STLeftSliderView.h
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STLeftSliderViewDelegate <NSObject>

@optional
-(void)goBack;

@end
@interface STLeftSliderView : UIView
@property (weak, nonatomic) IBOutlet UITableView *sliderTableView;
@property (weak, nonatomic) IBOutlet UIButton *portraitBtn;
- (IBAction)modifyPortraitClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

+(instancetype)initWithSliderView;

@property(nonatomic,weak)id<STLeftSliderViewDelegate> delegate;

@end
