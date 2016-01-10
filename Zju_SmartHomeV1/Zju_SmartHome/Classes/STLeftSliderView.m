//
//  STLeftSliderView.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STLeftSliderView.h"

@implementation STLeftSliderView

- (IBAction)modifyPortraitClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gotoUserInfo)]) {
        [self.delegate gotoUserInfo];
    }
}

- (IBAction)backBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}

+(instancetype)initWithSliderView
{
    STLeftSliderView *leftSliderView=[[[NSBundle mainBundle]loadNibNamed:@"STLeftSliderView" owner:nil options:nil]lastObject];
    return leftSliderView;
}

@end
