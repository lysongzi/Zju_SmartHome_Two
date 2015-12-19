//
//  JYRegisterXib.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterXibDelegate <NSObject>

@optional
-(void)registerXib:(NSString *)username and:(NSString *)password and:(NSString *)email;
-(void)backClick;
@end

@interface JYRegisterXib : UIView
+(instancetype)registerXib;

//用户名
@property (weak, nonatomic) IBOutlet UITextField *username;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *eyePicture;

@property(nonatomic,weak)id<RegisterXibDelegate>delegate;
@end
