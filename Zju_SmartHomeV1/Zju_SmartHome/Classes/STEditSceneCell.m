//
//  STSliderCell.m
//  sliderDemo
//
//  Created by 123 on 16/1/1.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STEditSceneCell.h"


@implementation STEditSceneCell

+(instancetype)initWithEditSceneCell
{
    STEditSceneCell *editSceneCell=[[[NSBundle mainBundle]loadNibNamed:@"STEditSceneCell" owner:nil options:nil]lastObject];
    
    editSceneCell.bgButton.userInteractionEnabled=NO;
    return editSceneCell;
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
