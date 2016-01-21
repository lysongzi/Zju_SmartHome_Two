//
//  JYLoginXib.h
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STResetPwdViewDelegate <NSObject>

@optional
// 重置密码
-(void)resetPwdWithUserName:(NSString *)userName andPwd:(NSString *)xinPwd;

@end

@interface STResetPwdView : UIView

+(instancetype)resetPwdView;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userName;

//密码
@property (weak, nonatomic) IBOutlet UITextField *password;

@property(nonatomic,weak)id<STResetPwdViewDelegate>delegate;
@end
