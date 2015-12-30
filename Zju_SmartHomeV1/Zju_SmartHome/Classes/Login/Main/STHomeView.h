//
//  STHomeView.h
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol STHomeViewDelegate <NSObject>

@optional
-(void)officeClick;
-(void)homeClick;
-(void)universalClick;
-(void)singleClick;

@end

@interface STHomeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

- (IBAction)officeClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)universalClick:(id)sender;
- (IBAction)singleClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;

@property(nonatomic,weak)id<STHomeViewDelegate> delegate;

+(instancetype)initWithHomeView;
@end
