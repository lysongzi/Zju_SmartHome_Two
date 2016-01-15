//
//  STLeftSliderView.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "YSNewSceneView.h"

@implementation YSNewSceneView


+(instancetype)initWithNewSceneView
{
    YSNewSceneView *newSceneView=[[[NSBundle mainBundle]loadNibNamed:@"YSNewSceneView" owner:nil options:nil]lastObject];
//    editSceneView.devicesTableView.bounces=NO;
    newSceneView.devicesTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    newSceneView.xinSceneName.placeholder=@"请点击输入场景名字";
    [newSceneView.xinSceneName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [newSceneView.xinSceneName setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    return newSceneView;
}

@end
