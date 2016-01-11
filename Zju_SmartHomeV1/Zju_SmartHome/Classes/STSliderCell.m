//
//  STSliderCell.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STSliderCell.h"


@implementation STSliderCell


+(instancetype)initWithSTSliderCell
{
    STSliderCell *sliderCell=[[[NSBundle mainBundle]loadNibNamed:@"STSliderCell" owner:nil options:nil]lastObject];
    
    return sliderCell;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
