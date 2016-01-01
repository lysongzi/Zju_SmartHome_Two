//
//  STLeftSliderView.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STLeftSliderView.h"
#import "UIImage+ST.h"

@implementation STLeftSliderView

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

+(instancetype)initWithSliderView
{
    STLeftSliderView *leftSliderView=[[[NSBundle mainBundle]loadNibNamed:@"STLeftSliderView" owner:nil options:nil]lastObject];
    UIImage *newImage=[UIImage circleImageWithName:@"头像" borderWith:4 borderColor:[UIColor whiteColor]];
    [leftSliderView.portraitBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    
    return leftSliderView;
}

@end
