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
      self.title = [[UILabel alloc] init];
      self.title.textColor = [UIColor blackColor];
      self.title.font = [UIFont systemFontOfSize:12];
      self.title.textAlignment = NSTextAlignmentCenter;
      
      UIView *view = [[UIView alloc] init];
      view.backgroundColor = [UIColor whiteColor];
      view.alpha = 0.6;
      self.view = view;

      [self.view addSubview:self.title];
      [self addSubview:self.view];
  }
  return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.title.frame = CGRectMake(0, 6, SCREEN_WIDTH - 36, 12);
    self.view.frame = CGRectMake(0,0, SCREEN_WIDTH - 36, 24);
}

@end
