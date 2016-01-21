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


-(void)setHighlighted:(BOOL)highlighted
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
