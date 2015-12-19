//
//  DLAddDeviceView.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLAddDeviceViewDelegate <NSObject>

@optional
-(void)addDeviceGoGoGo:(NSString *)deviceName and:(NSString *)deviceMac;
-(void)cancelAddDevice;
@end

@interface DLAddDeviceView : UIView
//设备名称
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
//设备Mac值
@property (weak, nonatomic) IBOutlet UITextField *deviceMac;
+(instancetype)addDeviceView;
@property(nonatomic,weak)id<DLAddDeviceViewDelegate>delegate;
@end
