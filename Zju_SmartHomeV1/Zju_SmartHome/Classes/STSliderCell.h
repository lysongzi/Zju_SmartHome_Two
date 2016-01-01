//
//  STSliderCell.h
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSliderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *descBtn;

- (IBAction)cellBtnClick:(UIButton *)sender;

+(instancetype)initWithSTSliderCell;
@end
