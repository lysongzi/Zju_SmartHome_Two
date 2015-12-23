//
//  YSPatter.h
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface YSPattern : NSObject

//模式名称
@property (copy, nonatomic) NSString *patternName;
//模式描述
@property (copy, nonatomic) NSString *descLabel;
//背景图标识
@property (copy, nonatomic) NSString *imgKey;
//缩略图
@property (weak, nonatomic) UIImage *thumbnail;
//是否被选中
@property (assign) BOOL isCheck;

- (instancetype)initWithPatternName:(NSString *)name desc:(NSString *)desc;
- (instancetype)initWithPatternName:(NSString *)name desc:(NSString *)desc picture:(NSString *)picture;
- (void)setThumbnailFromImage;

@end
