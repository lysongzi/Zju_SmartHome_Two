//
//  JYUserData.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYUserData : NSObject

//用户账号
@property(nonatomic,copy)NSString *account;
//用户头像
@property(nonatomic,copy)NSString *avatar;
//用户email
@property(nonatomic,copy)NSString *email;
//用户id
@property(nonatomic,copy)NSString *ID;

+(instancetype)dataWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
