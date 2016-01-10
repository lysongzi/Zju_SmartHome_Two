//
//  STLeftSliderView.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STUserInfoView.h"

@implementation STUserInfoView

- (IBAction)modifyPortraitClick:(id)sender
{
    NSLog(@"修改头像");
}

- (IBAction)backBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}

+(instancetype)initWithUserView
{
    STUserInfoView *userInfoView=[[[NSBundle mainBundle]loadNibNamed:@"STUserInfoView" owner:nil options:nil]lastObject];
    userInfoView.userActTableView.bounces=NO;
    userInfoView.userActTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return userInfoView;
}

@end
