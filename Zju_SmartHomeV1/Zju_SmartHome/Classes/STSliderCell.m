//
//  STSliderCell.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STSliderCell.h"


@implementation STSliderCell


- (IBAction)cellBtnClick:(UIButton *)sender
{
    NSLog(@"==%@",sender.titleLabel.text);
   
}

+(instancetype)initWithSTSliderCell
{
    STSliderCell *sliderCell=[[[NSBundle mainBundle]loadNibNamed:@"STSliderCell" owner:nil options:nil]lastObject];
    sliderCell.cellView.layer.cornerRadius=18;
    sliderCell.cellView.layer.masksToBounds=YES;
    sliderCell.cellView.layer.borderWidth=0.5;
    sliderCell.cellView.layer.borderColor=[[UIColor blackColor] CGColor];
    
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
