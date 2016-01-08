//
//  STAddDeviceView.m
//  手动添加智能设备
//
//  Created by 123 on 16/1/5.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STAddDeviceView.h"

@implementation STAddDeviceView

+(instancetype)addDeviceView
{
    STAddDeviceView *addView=[[[NSBundle mainBundle]loadNibNamed:@"STAddDeviceVew" owner:nil options:nil]lastObject];
    return addView;
}

- (IBAction)nextBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(next:and:)]) {
        [self.delegate next:self.customName.text and:self.mac.text];
    }
}

- (IBAction)cancelBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}



@end
