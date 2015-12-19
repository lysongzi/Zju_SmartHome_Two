//
//  JYLoginXib.h
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginXibDelegate <NSObject>

@optional
//登录
-(void)loginGoGoGo:(NSString *)username and:(NSString *)password;

//忘记密码
- (void)forgetPasswordGO;

//注册
-(void)registerGoGoGo;

@end


@interface JYLoginXib : UIView
+(instancetype)loginXib;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *username;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *eyePicture;

@property(nonatomic,weak)id<LoginXibDelegate>delegate;
@end
