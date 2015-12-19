//
//  ZQSlider.m
//  day4-ui
//
//  Created by qianfeng on 15/12/2.
//  Copyright (c) 2015年 TooWalker. All rights reserved.
//

#import "ZQSlider.h"

@implementation ZQSlider

//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
//    
//}
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
//    
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"%@",self.subviews);
    
    for (UIImageView* imageView in self.subviews) {
        if (imageView.frame.origin.x < self.center.x) {
//            NSLog(@"%d", (int)self.center.x);
//            NSLog(@"%@", imageView);
            imageView.contentMode = UIViewContentModeLeft;
        }
    }
}

@end
