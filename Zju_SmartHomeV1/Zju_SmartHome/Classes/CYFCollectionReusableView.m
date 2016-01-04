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

@interface CYFCollectionReusableView ()

@property (assign) float width;

@end

@implementation CYFCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      self.title = [[UILabel alloc] init];
      self.title.textColor = [UIColor blackColor];
      self.title.font = [UIFont systemFontOfSize:15];
      self.title.textAlignment = NSTextAlignmentCenter;
      
      UIImageView *view = [[UIImageView alloc] init];
      view.image = [UIImage imageNamed:@"jiaju_btn_white_bg"];
      self.view = view;

      [self.view addSubview:self.title];
      [self addSubview:self.view];
      //NSLog(@"%f", frame.size.width);
      self.width = frame.size.width;
  }
  return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    float height = 42 * (SCREEN_WIDTH / 320);
    //NSLog(@"%f", height);
    self.title.frame = CGRectMake(0, 4, self.width, 15 * (height / 42));
    self.view.frame = CGRectMake(0,12, self.width, 24 * (height / 42));
}

@end
