//
//  STSliderCell.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STNewSceneCell.h"


@implementation STNewSceneCell

+(instancetype)initWithNewSceneCell
{
    STNewSceneCell *newSceneCell=[[[NSBundle mainBundle]loadNibNamed:@"STNewSceneCell" owner:nil options:nil]lastObject];
    
    newSceneCell.bgButton.userInteractionEnabled=NO;
    return newSceneCell;
}

- (IBAction)switchBtn:(id)sender
{
    if (self.up_down.tag==1)
    {
        [self.up_down setBackgroundImage:[UIImage imageNamed:@"changjing_edit_btn_equipment_notadded"] forState:UIControlStateNormal];
        self.up_down.tag=0;
    }
    else if (self.up_down.tag==0)
    {
        [self.up_down setBackgroundImage:[UIImage imageNamed:@"changjing_edit_btn_equipment_added"] forState:UIControlStateNormal];
        self.up_down.tag=1;
    }
    
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
