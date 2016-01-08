//
//  STAddDeviceView.h
//  手动添加智能设备
//
//  Created by 123 on 16/1/5.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STAddDeviceDelegate <NSObject>

@optional
-(void)cancel;
-(void)next:(NSString *)deviceName and:(NSString *)deviceMac;
@end

@interface STAddDeviceView : UIView
@property (weak, nonatomic) IBOutlet UITextField *customName;
@property (weak, nonatomic) IBOutlet UITextField *mac;

- (IBAction)nextBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;

+(instancetype)addDeviceView;

@property(nonatomic,weak)id<STAddDeviceDelegate> delegate;
@end
