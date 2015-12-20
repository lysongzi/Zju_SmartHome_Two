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
    self = [super init];
    if (self) {
        _patternName = name;
        _descLabel = desc;
    }
    return self;
}

- (void)setThumbnailFromImage
{
    
}

@end
