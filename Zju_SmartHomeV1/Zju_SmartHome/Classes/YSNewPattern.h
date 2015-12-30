//
//  YSNewPattern.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/30.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNewPattern : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *logoName;
@property (copy, nonatomic) NSString *bkgName;

- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName;
- (instancetype)initWithName:(NSString *)name logoName:(NSString *)logoName bkgName:(NSString *)bkgName;

@end
