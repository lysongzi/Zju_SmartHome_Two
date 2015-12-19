//
//  DLAddDeviceView.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLAddDeviceView.h"

@interface DLAddDeviceView()
@property (weak, nonatomic) IBOutlet UIView *middleView;
- (IBAction)cancelAdd:(id)sender;
- (IBAction)addDevice:(id)sender;
@end

@implementation DLAddDeviceView

+(instancetype)addDeviceView
{
    DLAddDeviceView *addDeviceView=[[[NSBundle mainBundle]loadNibNamed:@"DLAddDeviceViewXib" owner:nil options:nil]lastObject];
    //设置圆角
    addDeviceView.middleView.layer.cornerRadius=5;
    addDeviceView.middleView.layer.masksToBounds=YES;
    return addDeviceView;
}

//取消添加设备
- (IBAction)cancelAdd:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cancelAddDevice)])
    {
        [self.delegate cancelAddDevice];
    }
}

//添加设备
- (IBAction)addDevice:(id)sender
{
    if([self.delegate respondsToSelector:@selector(addDeviceGoGoGo:and:)])
    {
        [self.delegate addDeviceGoGoGo:self.deviceName.text and:self.deviceMac.text];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
  [self.deviceName resignFirstResponder];
  [self.deviceMac resignFirstResponder];
}
@end
