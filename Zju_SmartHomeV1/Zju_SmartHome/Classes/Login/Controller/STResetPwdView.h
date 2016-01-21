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
-(void)resetPwdGoGoGo;

@end

@interface STResetPwdView : UIView

+(instancetype)resetPwdView;

//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *eyePicture;

@property(nonatomic,weak)id<STResetPwdViewDelegate>delegate;
@end
