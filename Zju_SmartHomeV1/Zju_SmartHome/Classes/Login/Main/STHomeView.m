//
//  STHomeView.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//
#import "STHomeView.h"

@implementation STHomeView

- (IBAction)officeClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(officeClick)])
    {
        [self.delegate officeClick];
    }
}

- (IBAction)homeClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(homeClick)])
    {
        [self.delegate homeClick];
    }
}

- (IBAction)universalClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(universalClick)])
    {
        [self.delegate universalClick];
    }
}

- (IBAction)singleClick:(id)sender
{
    if([self.delegate respondsToSelector:@selector(singleClick)])
    {
        [self.delegate singleClick];
    }
}

+(instancetype)initWithHomeView
{
    STHomeView *homeView=[[[NSBundle mainBundle]loadNibNamed:@"STHomeView" owner:nil options:nil]lastObject];
    
    return homeView;
}
@end
