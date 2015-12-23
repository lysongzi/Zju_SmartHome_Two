//
//  YSPatter.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSPattern.h"

@implementation YSPattern

- (instancetype)initWithPatternName:(NSString *)name desc:(NSString *)desc
{
    return [self initWithPatternName:name desc:desc picture:nil];
}

- (instancetype)initWithPatternName:(NSString *)name desc:(NSString *)desc picture:(NSString *)picture
{
    self = [super init];
    if (self) {
        _patternName = name;
        _descLabel = desc;
        _imgKey = picture;
        _isCheck = NO;
    }
    return self;
}

- (void)setThumbnailFromImage
{
    
}

@end
