//
//  CYFCollectionReusableView.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionReusableView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation CYFCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
      self.title=[[UILabel alloc]init];
      self.title.textColor=[UIColor blackColor];
      self.title.textAlignment=NSTextAlignmentCenter;

      UIView *topView=[[UIView alloc]init];
      topView.backgroundColor=[UIColor grayColor];
      self.topView=topView;
      //[self.topView setBackgroundColor:[UIColor colorWithRed:212 green:255 blue:100 alpha:1.0]];
      
      
      UIView *view=[[UIView alloc]init];
      self.view=view;

      [self.view addSubview:self.title];
      [self.view addSubview:self.topView];
      
      [self addSubview:self.view];
      
    
  }
  return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.topView.frame=CGRectMake(0, 44, self.window.frame.size.width, 1);
    self.title.frame=CGRectMake(0, 10, self.window.frame.size.width, 25);
    self.view.frame=CGRectMake(0,0, self.window.frame.size.width, 45);
}

@end
