//
//  CYFCollectionViewCell.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionViewCell.h"
#import "JYFurnitureView.h"
#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define UISCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CYFCollectionViewCell()
@property(nonatomic,strong)JYFurnitureView *furnitureView;
@end

@implementation CYFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
      JYFurnitureView *furnitureView=[JYFurnitureView furnitureViewXib];
      self.furnitureView = furnitureView;
      [self addSubview:self.furnitureView];

      self.imageButton = furnitureView.imageBtn;
//      [self.imageButton setAdjustsImageWhenHighlighted:NO];
      self.descLabel = furnitureView.descLabel;
      self.bottomX = furnitureView.bottomX;
      self.rightX = furnitureView.rightX;
      self.topX = furnitureView.topX;
    
    self.closeButton = furnitureView.closeButton;

  }
  return self;
}

//这个方法里调整控件frame是最准确的
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.furnitureView.frame=CGRectMake(0, 0, UISCREEN_WIDTH/ 3, UISCREEN_WIDTH/ 3);
}
@end
