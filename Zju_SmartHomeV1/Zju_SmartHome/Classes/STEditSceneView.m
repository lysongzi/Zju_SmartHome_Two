//
//  STLeftSliderView.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STEditSceneView.h"

@implementation STEditSceneView


+(instancetype)initWithEditSceneView
{
    STEditSceneView *editSceneView=[[[NSBundle mainBundle]loadNibNamed:@"STEditSceneView" owner:nil options:nil]lastObject];

    editSceneView.devicesTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return editSceneView;
}

@end
